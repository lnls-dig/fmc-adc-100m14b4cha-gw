files = [
    "afc_ref_fmc_adc_100Ms.vhd",
    "afc_ref_fmc_adc_100Ms_fmc.xdc",
    "afc_ref_fmc_adc_100Ms.xdc",
]

fetchto = "../../ip_cores"

modules = {
    "local" : [
    "../../../",
    ],
    "git" : [
        "https://github.com/lnls-dig/infra-cores.git",
	    "https://github.com/lnls-dig/general-cores-lnls.git",
        "https://github.com/lnls-dig/afc-gw.git",
    ],
}
