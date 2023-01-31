### Print micro-channels with Nanoscribe

This protocol describes the procedures of printing micro-channels using Nanoscribe two-photon 3D printer at UPMC campus.

#### Nanoscribe preparation

**Turn on Nanoscribe**

Nanoscribe is essentially a microscope coupled with precise motorized stages, which are controlled by a computer. To turn it on, we turn on the main controller, computer, (bottom right I don't know what) and laser in order. They are all in a cupboard under the main machine. Above the cupboard, there is a switch for the microscope, which also needs to be turned on.

**Open the main chamber**

Once everything is on, we can open the main chamber of Nanoscribe. First, unlock the box with the red knob on the very left side. Then, press the "reset" button twice (or more), until the "open" button is blinking. Press "open", the box will open.

**Install objective**

Take the 25X objective from the (2nd) drawer. Put a white rubber collar around the objective to prevent damages from flowing resin or oil. Then put the objective on the right port.

#### Sample preparation

- Sample holder
- scotch tape (green)
- tweezer
- cut silicon wafer
- IPS resin

Put a piece of square silicon wafer on the right spot of sample holder, fix with tape. Put a drop of resin in the middle of the wafer. Note that we don't use the first drop that comes out of the resin tube. Flip the sample holder and load it on Nanoscribe.

#### Software

Login the computer as "user", with password "nanoscribeuser".

**deScribe**

- Open .stl file in deScribe, choose IPS 25X Shell recipe and click through to generate .gwl job file. 
- Use some for loops to repeat a design several times on the wafer. The range
should be 10 mm (X) x 20 mm (Y). Use include to invoke the design.
- Save another .gwl for the final printing job.

**whiteScribe**

- approach sample
- load .gwl
- start the job

#### Development

- Take the printed resin out of the chamber
- Put it on a specially designed metal holder, which usually sits in a small beaker
- Develop in PGMEA for 20 min
- Wash in IPA for 2 min
- Dry with air from the back of wafer

#### Clean the objective

- Prepare
    - two pieces of cleanroom tissue
    - PGMEA bottle with pipette
    - IPA bottle with pipette
- Fold the tissue to have a hard edge
- Wipe out the leftover resin as much as possible (avoid touching the lens part)
- Put several drops of IPA on the lens, hold the objective with another tissue, so that solvent does not flow everywhere
- Blow away the solvent/resin mixture with air pistol, then wipe out the mess
- repeat the IPA/blow process twice
- Put several drops of PGMEA on the lense and blow away, like IPA
- Wash one last time with IPA, air dry

#### Log

- Maxpower log
- Activity log



