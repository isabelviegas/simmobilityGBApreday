# simmobilityGBApreday
This repository contains the travel demand models estimated for the Greater Boston Area for implementation in SimMobility. All files include the estimation and latest implementation files. The estimation files are PythonBiogeme outputs. The implementation files are in Lua. These are interfaced with SimMobility.

(Lu, Y, Adnan, M, Basak, K, Pereira, FC, Carrion, C, Saber, VH, Loganathan, H and Ben- Akiva, M. (2015). Simmobility mid-term simulator: A state of the art integrated agent based demand and supply model. In 94th Annual Meeting of the Transportation Research Board, Washington, DC.)

The folder named original contains the initial estimation results and Lua implementations. The folder contains the following sub-folders:

1.dpb - Day Pattern Travel

2.dpt - Day Pattern Tours

3.dps - Day Pattern Stops

4.nt - Number of Tours

	4a.ntw - Number of Tours (Work)

	4b.nte - Number of Tours (Education)

	4c.ntp - Number of Tours (Personal)

	4d.ntr - Number of Tours (Recreation)

	4e.nts - Number of Tours (Shop)

	4f.ntes - Number of Tours (Escort)

5.tuw - Tour Usual Work

6.tm - Tour Mode

	6a.tmw - Tour Mode (Work)

	6b.tme -Tour Mode (Education)

7.md - Mode Destination

	7a.tmdw - Tour Mode Destination (Work)

	7c.tmdp - Tour Mode Destination (Personal)

	7d.tmdr - Tour Mode Destination (Recreation)

	7e.tmds - Tour Mode Destination (Shop)

	7f.tmdes - Tour Mode Destination (Escort)

8.ttd - Tour Time of Day

	8a.ttdw - Tour Time of Day (Work)

	8b.ttde - Tour Time of Day (Education)

	8c.ttdp - Tour Time of Day (Personal)

	8d.ttdr - Tour Time of Day (Recreation)

	8e.ttds - Tour Time of Day (Shop)

	8f.ttdes - Tour Time of Day (Escort)

9.isg - Intermediate Stop Generation

10.imd - Intermediate Stop Mode Destination

11.itd - Intermediate Stop Time of Day

12.tws - Workbased Subtour Generation

13.stmd - Workbased Subtour Mode Destination

14.sttd - Workbased Subtour Time of Day

Due to GitHub space constraints, the example Day Activity Schedule can be found the the following Google Drive folder:
https://drive.google.com/drive/folders/1i8uQrZQfpde0U0wWxTcsVUMNoXiLGImn?usp=sharing

For questions regarding this folder, please contact iviegas@mit.edu.

The folder april_imp contains the version of the Lua files that was implemented as in April, 2018. Modifications that has been done since the original estimations include the following main points.

1. The models are further calibrated to match the MTS data. This process was also based on other data sources such as the demand generated from the CTPS four-step model.

2. New modes which didn't exist in the MTS survey were added to the mode and mode/destination model based on more up-to-date data sources.

For questions regarding this folder, please contact yifeix@mit.edu

The project as a whole is a work in progress and is constantly evolving.
