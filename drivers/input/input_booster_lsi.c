#include <linux/input/input_booster.h>
#include <linux/ems.h>
#include <linux/exynos-ucc.h>

static struct emstune_mode_request emstune_req_input;
static struct pm_qos_request cluster2_qos;
static struct pm_qos_request cluster1_qos;
static struct pm_qos_request cluster0_qos;
static struct pm_qos_request mif_qos;
static struct pm_qos_request int_qos;
static struct ucc_req ucc_req =
{
	.name = "input",
};

static DEFINE_MUTEX(input_lock);
bool current_hmp_boost = INIT_ZERO;
bool current_ucc_boost = INIT_ZERO;

struct inform {
  void *qos;
  void (*set_func)(int);
  int release_value;
};
struct inform informations[MAX_RES_COUNT];

void set_ucc(int enable) {
	mutex_lock(&input_lock);

	if (enable != current_ucc_boost) {
		pr_booster("[Input Booster2] ******      set_ucc : %d ( %s )\n", enable, __FUNCTION__);
		if (enable) {
			ucc_add_request(&ucc_req, INPUT_LEVEL);
		} else {
			ucc_remove_request(&ucc_req);
		}
		current_ucc_boost = enable;
	}

	mutex_unlock(&input_lock);
}


void set_hmp(int enable) {
	mutex_lock(&input_lock);

	if (enable != current_hmp_boost) {
		pr_booster("[Input Booster2] ******      set_ehmp : %d ( %s )\n", enable, __FUNCTION__);
		if (enable) {
			emstune_update_request(&emstune_req_input, INPUT_LEVEL);
		} else {
			emstune_update_request(&emstune_req_input, DEFAULT_LEVEL);
		}
		current_hmp_boost = enable;
	}

	mutex_unlock(&input_lock);
}

void init_input_emstune(void) {
	emstune_add_request(&emstune_req_input);
}

void ib_set_booster(int* qos_values)
{
	int value = -1;
	int res_type = 0;

	for (res_type = 0; res_type < MAX_RES_COUNT; res_type++) {
		pr_info(" ib_set_booster qos_values[%d] : %d", res_type, qos_values[res_type]);
		value = qos_values[res_type];

		if (value <= 0)
			continue;

		if (informations[res_type].qos) {
			pm_qos_update_request(informations[res_type].qos, qos_values[res_type]);
		} else {
			informations[res_type].set_func(qos_values[res_type]);
		}
	}
}

void ib_release_booster(long *rel_flags)
{
	int res_type = 0;
	long flag = -1;

	for (res_type = 0; res_type < MAX_RES_COUNT; res_type++) {
		flag = rel_flags[res_type];
		if (flag <= 0)
			continue;

		if (informations[res_type].qos) {
			pm_qos_update_request(informations[res_type].qos, informations[res_type].release_value);
		} else {
			informations[res_type].set_func(informations[res_type].release_value);
		}
	}
}

void input_booster_init_vendor(int* release_val)
{
	int i = 0;
	pm_qos_add_request(&cluster2_qos, PM_QOS_CLUSTER2_FREQ_MIN, PM_QOS_CLUSTER2_FREQ_MIN_DEFAULT_VALUE);
	pm_qos_add_request(&cluster1_qos, PM_QOS_CLUSTER1_FREQ_MIN, PM_QOS_CLUSTER1_FREQ_MIN_DEFAULT_VALUE);
	pm_qos_add_request(&cluster0_qos, PM_QOS_CLUSTER0_FREQ_MIN, PM_QOS_CLUSTER0_FREQ_MIN_DEFAULT_VALUE);
	pm_qos_add_request(&mif_qos, PM_QOS_BUS_THROUGHPUT, PM_QOS_BUS_THROUGHPUT_DEFAULT_VALUE);
	pm_qos_add_request(&int_qos, PM_QOS_DEVICE_THROUGHPUT, PM_QOS_DEVICE_THROUGHPUT_DEFAULT_VALUE);
	
	informations[i++].qos = &cluster2_qos;
	informations[i++].qos = &cluster1_qos;
	informations[i++].qos = &cluster0_qos;
	informations[i++].qos = &mif_qos;
	informations[i++].qos = &int_qos;
	informations[i++].set_func = set_hmp;
	informations[i++].set_func = set_ucc;

	for (i = 0; i < MAX_RES_COUNT; i++) {
		informations[i].release_value = release_val[i];
	}

	init_input_emstune();
}

void input_booster_exit_vendor()
{
	pm_qos_remove_request(&cluster2_qos);
	pm_qos_remove_request(&cluster1_qos);
	pm_qos_remove_request(&cluster0_qos);
	pm_qos_remove_request(&mif_qos);
	pm_qos_remove_request(&int_qos);
}
