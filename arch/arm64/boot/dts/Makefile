# SPDX-License-Identifier: GPL-2.0
dtb-y += exynos/exynos9830.dtb

dtbo-$(CONFIG_MODEL_X1SLTE) += samsung/exynos990-x1slte_eur_open_00.dtbo
dtbo-$(CONFIG_MODEL_X1SLTE) += samsung/exynos990-x1slte_eur_open_21.dtbo

dtbo-$(CONFIG_MODEL_X1S) += samsung/exynos990-x1s_eur_open_05.dtbo
dtbo-$(CONFIG_MODEL_X1S) += samsung/exynos990-x1s_eur_open_16.dtbo
dtbo-$(CONFIG_MODEL_X1S) += samsung/exynos990-x1s_eur_open_17.dtbo
dtbo-$(CONFIG_MODEL_X1S) += samsung/exynos990-x1s_eur_open_19.dtbo
dtbo-$(CONFIG_MODEL_X1S) += samsung/exynos990-x1s_eur_open_21.dtbo

dtbo-$(CONFIG_MODEL_Y2SLTE) += samsung/exynos990-y2slte_eur_open_00.dtbo
dtbo-$(CONFIG_MODEL_Y2SLTE) += samsung/exynos990-y2slte_eur_open_21.dtbo

dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_04.dtbo
dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_05.dtbo
dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_06.dtbo
dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_16.dtbo
dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_17.dtbo
dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_18.dtbo
dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_19.dtbo
dtbo-$(CONFIG_MODEL_Y2S) += samsung/exynos990-y2s_eur_open_21.dtbo

dtbo-$(CONFIG_MODEL_Z3S) += samsung/exynos990-z3s_eur_open_16.dtbo
dtbo-$(CONFIG_MODEL_Z3S) += samsung/exynos990-z3s_eur_open_17.dtbo
dtbo-$(CONFIG_MODEL_Z3S) += samsung/exynos990-z3s_eur_open_18.dtbo
dtbo-$(CONFIG_MODEL_Z3S) += samsung/exynos990-z3s_eur_open_20.dtbo
dtbo-$(CONFIG_MODEL_Z3S) += samsung/exynos990-z3s_eur_open_21.dtbo
dtbo-$(CONFIG_MODEL_Z3S) += samsung/exynos990-z3s_eur_open_22.dtbo
dtbo-$(CONFIG_MODEL_Z3S) += samsung/exynos990-z3s_eur_open_24.dtbo

dtbo-$(CONFIG_MODEL_C1SLTE) += samsung/exynos990-c1slte_eur_open_21.dtbo
dtbo-$(CONFIG_MODEL_C1SLTE) += samsung/exynos990-c1slte_eur_open_24.dtbo
dtbo-$(CONFIG_MODEL_C1SLTE) += samsung/exynos990-c1slte_eur_open_22.dtbo
dtbo-$(CONFIG_MODEL_C1SLTE) += samsung/exynos990-c1slte_eur_open_20.dtbo

dtbo-$(CONFIG_MODEL_C1S) += samsung/exynos990-c1s_eur_open_22.dtbo
dtbo-$(CONFIG_MODEL_C1S) += samsung/exynos990-c1s_eur_open_20.dtbo
dtbo-$(CONFIG_MODEL_C1S) += samsung/exynos990-c1s_eur_open_21.dtbo
dtbo-$(CONFIG_MODEL_C1S) += samsung/exynos990-c1s_eur_open_18.dtbo
dtbo-$(CONFIG_MODEL_C1S) += samsung/exynos990-c1s_eur_open_00.dtbo
dtbo-$(CONFIG_MODEL_C1S) += samsung/exynos990-c1s_eur_open_19.dtbo
dtbo-$(CONFIG_MODEL_C1S) += samsung/exynos990-c1s_eur_open_24.dtbo

dtbo-$(CONFIG_MODEL_C2SLTE) += samsung/exynos990-c2slte_eur_open_21.dtbo
dtbo-$(CONFIG_MODEL_C2SLTE) += samsung/exynos990-c2slte_eur_openx_19.dtbo
dtbo-$(CONFIG_MODEL_C2SLTE) += samsung/exynos990-c2slte_eur_open_24.dtbo
dtbo-$(CONFIG_MODEL_C2SLTE) += samsung/exynos990-c2slte_eur_open_23.dtbo
dtbo-$(CONFIG_MODEL_C2SLTE) += samsung/exynos990-c2slte_eur_open_22.dtbo

dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_23.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_18.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_22.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_21.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_19.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_00.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_24.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_16.dtbo
dtbo-$(CONFIG_MODEL_C2S) += samsung/exynos990-c2s_eur_openx_17.dtbo

dtbo-$(CONFIG_MODEL_R8S) += samsung/exynos990-r8s_eur_open_00.dtbo
dtbo-$(CONFIG_MODEL_R8S) += samsung/exynos990-r8s_eur_open_02.dtbo
dtbo-$(CONFIG_MODEL_R8S) += samsung/exynos990-r8s_eur_open_05.dtbo

targets += dtbs
DTB_LIST  := $(dtb-y) $(dtbo-y)
always    := $(DTB_LIST)

dtbs: $(addprefix $(obj)/, $(DTB_LIST))

clean-files := *.dtb*
