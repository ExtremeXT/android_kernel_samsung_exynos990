# SPDX-License-Identifier: GPL-2.0
dtb-y += exynos/exynos5433-tm2.dtb
dtb-y += exynos/exynos5433-tm2e.dtb
dtb-y += exynos/exynos7-espresso.dtb
dtb-y += exynos/exynos9830.dtb
dtb-y += exynos/exynos9830-smdk9830_r02.dtb
dtb-y += exynos/exynos9830-universal9830_r04.dtb
dtb-y += exynos/exynos9830-universal9830_r05.dtb
dtb-y += exynos/exynos9830-universal9830_r06.dtb
dtb-y += exynos/exynos9830-universal9830_r10.dtb

dtbo-y += samsung/exynos990-x1s_eur_open_05.dtbo
dtbo-y += samsung/exynos990-x1s_eur_open_16.dtbo
dtbo-y += samsung/exynos990-x1s_eur_open_17.dtbo
dtbo-y += samsung/exynos990-x1s_eur_open_19.dtbo
dtbo-y += samsung/exynos990-x1s_eur_open_21.dtbo
dtbo-y += samsung/exynos990-x1slte_eur_open_00.dtbo
dtbo-y += samsung/exynos990-x1slte_eur_open_21.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_04.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_05.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_06.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_16.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_17.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_18.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_19.dtbo
dtbo-y += samsung/exynos990-y2s_eur_open_21.dtbo
dtbo-y += samsung/exynos990-y2slte_eur_open_00.dtbo
dtbo-y += samsung/exynos990-y2slte_eur_open_21.dtbo
dtbo-y += samsung/exynos990-z3s_eur_open_16.dtbo
dtbo-y += samsung/exynos990-z3s_eur_open_17.dtbo
dtbo-y += samsung/exynos990-z3s_eur_open_18.dtbo
dtbo-y += samsung/exynos990-z3s_eur_open_20.dtbo
dtbo-y += samsung/exynos990-z3s_eur_open_21.dtbo
dtbo-y += samsung/exynos990-z3s_eur_open_22.dtbo
dtbo-y += samsung/exynos990-z3s_eur_open_24.dtbo

dtbo-y += samsung/exynos990-c1s_eur_open_22.dtbo
dtbo-y += samsung/exynos990-c1s_eur_open_20.dtbo
dtbo-y += samsung/exynos990-c1s_eur_open_21.dtbo
dtbo-y += samsung/exynos990-c1s_eur_open_18.dtbo
dtbo-y += samsung/exynos990-c1s_eur_open_00.dtbo
dtbo-y += samsung/exynos990-c1s_eur_open_19.dtbo
dtbo-y += samsung/exynos990-c1s_eur_open_24.dtbo

targets += dtbs
DTB_LIST  := $(dtb-y) $(dtbo-y)
always    := $(DTB_LIST)

dtbs: $(addprefix $(obj)/, $(DTB_LIST))

clean-files := *.dtb*
