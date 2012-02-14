// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>

#ifdef __ethernet_conf_h_exists__
#include "ethernet_conf.h"
#endif

#include "miiDriver.h"
#include "miiLLD.h"
#include "mii.h"
#include "smi.h"

void miiInitialise(clock clk_smi,
        out port ?p_mii_resetn,
		smi_interface_t &smi,
		mii_interface_t &m)
{
#ifndef MII_DRIVER_SIMULATION
#ifndef MII_NO_RESET
    if (!isnull(p_mii_resetn)) {
        timer tmr;
        phy_reset(p_mii_resetn, tmr);
    }
#endif
	smi_port_init(clk_smi, smi);
    mii_port_init(m);
#ifndef MII_NO_SMI_CONFIG
	eth_phy_config(1, smi);
#endif
#else
    mii_port_init(m);
#endif
}

void miiDriver(mii_interface_t &m, chanend cIn, chanend cOut)
{
    timer tmr;
    miiLLD(m.p_mii_rxd, m.p_mii_rxdv, m.p_mii_txd, cIn, cOut, m.p_mii_timing, tmr);
}

int miiCheckLinkState(smi_interface_t &smi)
{
	return eth_phy_checklink(smi);
}