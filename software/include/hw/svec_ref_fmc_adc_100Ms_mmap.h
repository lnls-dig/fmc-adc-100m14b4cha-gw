#ifndef __CHEBY__SVEC_REF_FMC_ADC_100M_MMAP__H__
#define __CHEBY__SVEC_REF_FMC_ADC_100M_MMAP__H__

#include "fmc_adc_mezzanine_mmap.h"
#define SVEC_REF_FMC_ADC_100M_MMAP_SIZE 32768 /* 0x8000 = 32KB */

/* a ROM containing the application metadata */
#define SVEC_REF_FMC_ADC_100M_MMAP_METADATA 0x2000UL
#define SVEC_REF_FMC_ADC_100M_MMAP_METADATA_SIZE 64 /* 0x40 */

/* FMC ADC Mezzanine slot 1 */
#define SVEC_REF_FMC_ADC_100M_MMAP_FMC1_ADC_MEZZANINE 0x4000UL
#define SVEC_REF_FMC_ADC_100M_MMAP_FMC1_ADC_MEZZANINE_SIZE 8192 /* 0x2000 = 8KB */

/* FMC ADC Mezzanine slot 2 */
#define SVEC_REF_FMC_ADC_100M_MMAP_FMC2_ADC_MEZZANINE 0x6000UL
#define SVEC_REF_FMC_ADC_100M_MMAP_FMC2_ADC_MEZZANINE_SIZE 8192 /* 0x2000 = 8KB */

struct svec_ref_fmc_adc_100m_mmap {

  /* padding to: 2048 words */
  uint32_t __padding_0[2048];
  /* [0x2000]: SUBMAP a ROM containing the application metadata */
  uint32_t metadata[16];

  /* padding to: 4096 words */
  uint32_t __padding_1[2032];

  /* [0x4000]: SUBMAP FMC ADC Mezzanine slot 1 */
  struct fmc_adc_mezzanine_mmap fmc1_adc_mezzanine;

  /* [0x6000]: SUBMAP FMC ADC Mezzanine slot 2 */
  struct fmc_adc_mezzanine_mmap fmc2_adc_mezzanine;
};

#endif /* __CHEBY__SVEC_REF_FMC_ADC_100M_MMAP__H__ */
