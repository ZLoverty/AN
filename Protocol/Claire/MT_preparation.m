clear all
close all
clc

%===========================================
%===========================================
% Initial and final concentrations of MTs
c_MT=8; %mg/mL % final massic concentraton of microtubules in the mix. 
%we want 8 mg/mL to have short MT
labelling_eff=0.41; %labelling efficiency of labelled tubulin. 
%41% effectively carry Alexa-647 fluorophore
conc_unlabeled=18; %mg/mL massic concentration of tubulin in unlabelled tubulin samples
conc_labeled= 31; %mg/mL massic concentration of tubulin in labelled tubulin samples 
per_labeled=0.033; % target fraction of fluorescently labelled tubulin in MT
%we want 3%
%===========================================
%===========================================

% Concentrations of the other components (initial, c0, and final, c)
c0_GMPCPP=10; %mM
c_GMPCPP=0.6; %mM
c0_DTT25=20; %mM
c_DTT25=1; %mM

prompt = ['Enter desired volume in ',char(956),'L']; %char(956) és per posar mu
dlg_title = 'Input';
num_lines = 1;
defaultans = {'100.0'};
Vtotal = inputdlg(prompt,dlg_title,num_lines,defaultans);
Vtotal=str2num(char(Vtotal));

V_GMPCPP=Vtotal*c_GMPCPP/c0_GMPCPP;
V_DTT25=Vtotal*c_DTT25/c0_DTT25;
m_tubulin=c_MT*Vtotal;
m_lab=m_tubulin*per_labeled;
m_unlab=m_tubulin*(1-per_labeled);
V_lab=m_lab/labelling_eff/conc_labeled;
V_unlab=(m_unlab-V_lab*conc_labeled*(1-labelling_eff))/conc_unlabeled;
V_M2B=Vtotal-V_GMPCPP-V_DTT25-V_lab-V_unlab;

string='You need (vol in uL):\n M2B: \t %s \n GMPCPP: \t %s \n DTT/25: \t %s\n Unlabelled tubulin: \t %s \n Labelled tubulin: \t %s';
string=sprintf(string, num2str(V_M2B), num2str(V_GMPCPP), num2str(V_DTT25)...
    , num2str(V_unlab), num2str(V_lab));
msgbox(string);
