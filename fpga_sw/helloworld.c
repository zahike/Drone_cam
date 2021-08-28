/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "SCCB.h"
#define START_FREQ   0x100
u32 *APB = XPAR_APB_M_0_BASEADDR;

int writeSCCB (int WriteData);
int write4readSCCB (int WriteData);
int readSCCB (int WriteData);


int main()
{
	int freq;
	int Hdata,Ldata,CamID;
    init_platform();

    xil_printf("Hello World\n\r");

    APB[5] = START_FREQ; // set SCCB clock to ~200Khz
	freq = 1000000/(START_FREQ*20);
	xil_printf("frequency %d \n\r",freq);

	APB[7] = 0x0;    	// set Camera reset
	usleep(100);
	APB[7] = 0x1;    	// Clear Camera reset
	usleep(100);

	write4readSCCB(0x78300a00);
	Hdata = readSCCB(0x78300a00);
	write4readSCCB(0x78300b00);
	Ldata = readSCCB(0x78300b00);

	CamID = (Hdata << 8) + Ldata;
	if (CamID == 0x5640) {
		xil_printf("Camera ID correct :):) Read %x \n\r",CamID);
	} else {
		xil_printf("Camera ID incorrect :(:(  Read %x \n\r",CamID);
	}


    xil_printf("GoodBye World\n\r");

    cleanup_platform();
    return 0;
}
