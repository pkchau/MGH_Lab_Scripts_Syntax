#NOTE: display size is 1024 x 768 on old exptl laptop, so this expt is set to 1024 x 768 to match.
#Point size of flankers stimuli for old expt = 56
#Note: monitor's refresh rate is: 60Hz = 60 frames of data per second/1 per 16.7ms --> request desired duration - 16.7/2 = request desired duration - 8 for all durations

#Header
response_matching = simple_matching;

#Closest Font to old expt font which is Courier New bolded. CANNOT do this b/c in old expt all text was bolded. Bolding text requires HTML tags so < > MUST be used as tags in order to format any text in this expt; incompatible w/ stimuli.
default_font = "Arial"; 

#keys: 1 = c, 2 = m, 3 = spacebar
active_buttons = 8;
button_codes = 1,2,3,4,5,6,7,8;

#Log file setup
stimulus_properties = subjectID,string, flankers,string, stim_arrows,string, condition,string, targ_buttons,string;
event_code_delimiter = ",";
#End Header
	
#Begin SDL
begin;

#Display ERROR as default if proper stimuli are not retrieved
array {
	text { caption = "ERROR"; description = "ERROR"; font_size = 100;} err;
} error;

#Create 3 separate arrays: 1 with flankers only and 1 with flankers w/ targets per condition (con/inc).
#NOTE: Make sure the order of each row in array 1 corresponds to array 2s and 3 i.e. that the flankers are the same in both.
#There are in total 4 different kinds of target w/ flankers stimuli. 
array {
	text { caption = "< <   < <"; description = "FLANKERS"; font_size = 100;};
   text { caption = "> >   > >"; description = "FLANKERS"; font_size = 100;};
} flankers_set;

array {
	text { caption = "< < < < <"; description = "CON"; font_size = 100;};
   text { caption = "> > > > >"; description = "CON"; font_size = 100;};
} con_target_set;


array {
	text { caption = "< < > < <"; description = "INC"; font_size = 100;};
	text { caption = "> > < > >"; description = "INC"; font_size = 100;};
} inc_target_set;

#Intro 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text {
				caption = "Real Flanker"; 
				font_size = 22;
			};
			x = 0; y = 150;
			text { 
				caption = "In this task, you will see 5 arrows presented.\n\nWe want you to focus on the direction the CENTER arrow is facing.\n\nPress the spacebar to proceed."; 
				font_size = 18; 
			};
			x = 0; y = 0;
		}; 
} intro_1;

#Intro 2
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
			text {
				caption = "Real Flanker"; 
				font_size = 22;
			};
			x = 0; y = 150;
			text { 
				caption = "You may place your left index finger on the 'c' key, and your right index finger on the 'm' key.\n\nIf you see the CENTER arrow is facing to the LEFT, you will press the 'c' key.\n\nIf the CENTER arrow is facing to the RIGHT, you will press the 'm' key.\n\nPress the spacebar to continue."; 
				font_size = 18; 
			};
		x = 0; y = -25;
		}; 
} intro_2;

#Example 1
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 2;
		picture {
			text {
				caption = "Real Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
			text {
				caption = "Example 1"; 
				font_size = 20;
			};
			x = 0; y = 75;
			text { 
				caption = "> > > > >"; 
				font_size = 70; 
			};
			x = 0; y = -25;
			text { 
				caption = "In this example, you would press the 'm' key as the CENTER arrow is facing to the RIGHT.\n\nPress the 'm' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -150;
		};  
} example_1;

#Example 2
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 2;
		picture {
			text {
				caption = "Real Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
			text {
				caption = "Example 2"; 
				font_size = 22;
			};
			x = 0; y = 75;
			text { 
				caption = "< < > < <"; 
				font_size = 70; 
			};
			x = 0; y = -25;
			text { 
				caption = "In this example, you would press the 'm' key as the CENTER arrow is facing to the RIGHT.\n\nPress the 'm' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -150;
			}; 
} example_2;

#Example 3
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text {
				caption = "Real Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
		text {
			caption = "Example 3"; 
			font_size = 22;
		};
		x = 0; y = 75;		
		text { 
			caption = "< < < < <"; 
			font_size = 70;
		};
		x = 0; y = -25;
		text { 
			caption = "For this example, you would press the 'c' key as the CENTER arrow is facing to the LEFT.\n\nPress the 'c' key to proceed."; 
			font_size = 18; 
		};
		x = 0; y = -150;
		};  
} example_3;

#Example 4
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 1;
		picture {
			text {
				caption = "Real Flanker"; 
				font_size = 22;
			};
			x = 0; y = 175;
			text {
				caption = "Example 4"; 
				font_size = 22;
			};
			x = 0; y = 75;
			text { 
				caption = "> > < > >"; 
				font_size = 70; 
			};
			x = 0; y = -25;
			text { 
				caption = "For this example, you would press the 'c' key as the CENTER arrow is facing to the LEFT.\n\nPress the 'c' key to proceed."; 
				font_size = 18; 
			};
			x = 0; y = -150;
			};  
} example_4;

#Begin Real Flanker
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
		picture {
		text { 
			caption = "We will now begin the real version of the task.\n\nRemember to be as QUICK and ACCURATE as you can.\n\nPress the spacebar when you are ready to start!"; 
			font_size = 18; 
		};
		x = 0; y = 0;
		}; 
} begin_real;

#Get Ready - Real Task
trial {
	trial_duration = 2992; 
	trial_type = fixed;
		picture {
		text { 
			caption = "Get ready!\n\nThe task is about to start!"; 
			font_size = 24; 
		};
		x = 0; y = 0;
		}; 
} get_ready_real;

#Flanker task
trial {
	trial_duration = 92; 
	trial_type = fixed;
	stimulus_event {
		picture {
			text err; 	
			x = 0; y = 0;
		} flankersonly_pic;
	} flankersonly_event;
} flankersonly;

#Flanker task: target
trial {
	trial_duration = 1442; #Will combine this trial w/ ISI (1400ms) since response window is 1500 in old expt. This will allow for slower responses but also not add to the 'blank screen' time
	trial_type = fixed;
	stimulus_event {
		picture {
			text err;
			x = 0; y = 0;
		} target_pic;
	code = 99;
	duration = 42; 
	} target_event;
} target;
		
#ITI
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
      } pic_ITI;
      time = 0;
      duration = 9999; #Durations will vary based on randomized array element (see below)
   } ITI_event;
} ITI;

#Feedback: Blank
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
      } pic_blank;
      time = 0;
      duration = 292; 
   } feedback_blank_event;
} feedback_blank;

#Feedback: TOO SLOW
trial {
   trial_duration = stimuli_length;
   all_responses = false;
   stimulus_event {
      picture {
         text {
				caption = "TOO SLOW!"; font_size = 48;
			};
         x = 0; y = 0;
      } pic_tooslow;
      time = 0;
      duration = 292;
   } feedback_tooslow_event;
} feedback_tooslow;

#End of block
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
	picture {
	text { 
		caption = "You have completed 1 block of the task.\n\nPlease take a moment to relax before starting the next block.\n\nWhen you are ready to continue, press the SPACEBAR."; 
		font_size = 24; 
	};
	x = 0; y = 0;
	} end_block_pic;	
} end_block; 

#Conclusion
trial {
	trial_duration = forever;
	trial_type = specific_response;
	terminator_button = 3;
	picture {
	text { 
		caption = "Great job!\n\nYou have completed the task.\n\nPlease let the experimenter know."; 
		font_size = 18; 
	};
	x = 0; y = 0;
	} conclusion_pic;	
} conclusion; 

begin_pcl;

preset string IP_address_of_NIC_laptop;

#LSL code
bool isConnected = false;
#Create socket
socket s = new socket();

#Set array of varying ITIs (200, 300, 400)
#Request 192, 292, 392 instead.
array<int> ITI_set[3] = {192, 292, 392};

#set # of stimuli for 1 block here.
#Note that we will have a stimuli ratio of 2 Congruent: 1 Incongruent to "build a tendency towards congruent responses" (based on Dr. Avram Holmes' programmed E-prime Flanker)
int num_inc_stimuli = 24;
int num_con_stimuli = num_inc_stimuli*2 - 2; 
int num_all_stimuli = 70;

array<text> flankers_only[0];
loop int i = 1 until i > num_all_stimuli/flankers_set.count() #Note: may need to add/subtract 1 if #s don't divide out evenly
begin
	loop int x = 1 until x > flankers_set.count()
	begin
		if (flankers_only.count() == num_all_stimuli) then
			break;
		end;
		flankers_only.add(flankers_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;
#Add con stim to array containing all flanker stim
array<text> flankers_target[0];
loop int i = 1 until i > num_con_stimuli/con_target_set.count() #Note: may need to add/subtract 1 if #s don't divide out evenly
begin;
	loop int x = 1 until x > con_target_set.count()
	begin
		if (flankers_target.count() == num_con_stimuli) then
			break;
		end;
		flankers_target.add(con_target_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;
#Add inc stimuli
loop int i = 1 until i > num_inc_stimuli/inc_target_set.count() #Note: may need to add/subtract 1 if #s don't divide out evenly
begin;
	loop int x = 1 until x > inc_target_set.count()
	begin
		if (flankers_target.count() == num_all_stimuli) then
			break;
		end;
	flankers_target.add(inc_target_set[x]);
	x = x + 1;
	end;
	i = i + 1;
end;

array<int> ITIs[0];
loop int i = 1 until i > num_all_stimuli/ITI_set.count()	+ 1 #Add 1 b/c 32/3 doesn't divide evenly and will round down
begin;
	loop int x = 1 until x > ITI_set.count()
	begin
		if (ITI_set.count() == num_all_stimuli) then
			break;
		end;
		ITIs.add(ITI_set[x]);
		x = x + 1;
	end;
	i = i + 1;
end;

#Create the randomizer array here
array<int> randomizer[0];
loop int i = 1 until i > num_all_stimuli
begin;
	randomizer.add(i);
	i = i + 1;
end;

#Randomize the order of the stimuli while maintaining the flanker x flanker w/ target pairs
randomizer.shuffle();

#Connect to NIC server. enter in IP address of NIC computer. NIC server runs on port 1234. SET time-out time
#8 bits for codification and no encryption
isConnected = s.open(IP_address_of_NIC_laptop,1234,5000,socket::ANSI,socket::UNENCRYPTED);
if isConnected == false then
	exit("\nThere is a problem w/ the cxn btwn the 2 computers.\nPlease restart the task.\nCheck that both computers are connected to the internet.\nCheck that the correct IP address was entered.\nOtherwise restart NIC and/or the computers and unplug and replug the cxns"); 
end;

#Present intro slides
intro_1.present();
intro_2.present();
example_1.present();
example_2.present();
example_3.present();
example_4.present();
begin_real.present();
get_ready_real.present();

#SET # blocks here
int num_blocks = 2;

array<int> targ_buttons[0]; #Array to contain target buttons/correct responses

#Present Flanker trials
loop int b = 1 until b > num_blocks
	begin
	loop int i = 1 until i > num_all_stimuli
	begin
		text t = flankers_target[randomizer[i]];
		flankersonly_pic.set_part(1, flankers_only[randomizer[i]]);
		target_pic.set_part(1, t);		
		flankersonly.present();
		if isConnected == true then 
		#Set the correct response depending on the stimulus displayed
			if (t.caption() == "< < < < <" || t.caption() == "> > < > >") then
				target_event.set_target_button(1);
				if t.caption() == "< < < < <" then
					s.send("<TRIGGER>11</TRIGGER>"); #NIC server processes a trigger whenever it receives a string with the following format: <TRIGGER>xxx</TRIGGER> with xxx = any # other than 0
				else
					s.send("<TRIGGER>12</TRIGGER>");
				end;		
			elseif (t.caption() == "> > > > >" || t.caption() == "< < > < <") then
				target_event.set_target_button(2);				
				if t.caption() == "> > > > >" then
					s.send("<TRIGGER>22</TRIGGER>");
				else
					s.send("<TRIGGER>21</TRIGGER>");
				end;
			else 
				s.send("<TRIGGER>100</TRIGGER>")
			end;	
		end;
		target_event.get_target_buttons(targ_buttons);
		target_event.set_event_code(logfile.subject() + "," + flankers_only[randomizer[i]].caption() + "," + t.caption() + "," + t.description() + "," + string(targ_buttons[1]));
		target.present();
		stimulus_data last = stimulus_manager.last_stimulus_data();
		#If response too slow, display too slow slide, otherwise display a blank slide
		if last.reaction_time() > 600 || last.reaction_time() == 0 then
			feedback_tooslow.present();
		else
			feedback_blank.present();
		end;
		ITI_event.set_duration(ITIs[randomizer[i]]);
		ITI.present();		
		i = i + 1;
	end;	
	#If there are more blocks to present, then present end of block message and randomize the stimuli again
	if b < num_blocks then
		end_block.present();
		randomizer.shuffle();
		get_ready_real.present();
	end;
	b = b + 1
end;

conclusion.present();