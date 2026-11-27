# Generic questionnaire template for Neurobehavioral Systems Presentation
# Item types: Likert (keys 1-7), free text (keyboard input), dichotomous (1 = YES, 2 = NO)
# Replace the placeholder items in the PCL section with those of your questionnaire.

active_buttons = 7;
button_codes = 1,2,3,4,5,6,7;
default_background_color = 255, 255, 255;
default_text_color = 0, 0, 0;
default_font_size = 5;
max_y = 100;                 # screen-independent units: the screen is 200 units high

begin;

# --- Likert / dichotomous question screen ---
text { caption = ""; font_size = 5; max_text_width = 170; } question_txt;
picture {
    text question_txt;
    x = 0; y = 0;
} question_pic;
trial {
    trial_type = first_response;
    trial_duration = forever;
    stimulus_event {
        picture question_pic;
        time = 0;
    } question_event;
} question_trial;

# --- Free-text question screen ---
text { caption = ""; font_size = 5; max_text_width = 160; } open_question_txt;
text { caption = ""; font_size = 5; max_text_width = 160; } answer_txt;
picture {
    text open_question_txt;
    x = 0; y = 25;
    text answer_txt;
    x = 0; y = -40;
} open_question_pic;

# --- Instructions / goodbye screen ---
text { caption = ""; font_size = 6; max_text_width = 170; } info_txt;
picture {
    text info_txt;
    x = 0; y = 0;
} info_pic;
trial {
    trial_type = first_response;
    trial_duration = forever;
    stimulus_event {
        picture info_pic;
        time = 0;
    } info_event;
} info_trial;

begin_pcl;

# ---------- CONFIGURATION ----------
string output_name = "questionnaire_results.csv";

# Texts come from EXPARAM (see README), so no code edits are needed to change them
string instructions = parameter_manager.get_string( "instructions", "Instructions" );
string goodbye      = parameter_manager.get_string( "end", "Thank you" );

string scale_anchors = "Strongly disagree   1   2   3   4   5   6   7   Strongly agree";

array<string> likert_items[0];
likert_items.add( "Likert item 1" );
likert_items.add( "Likert item 2" );
likert_items.add( "Likert item 3" );

array<string> open_items[0];
open_items.add( "Open question 1" );
open_items.add( "Open question 2" );

array<string> yesno_items[0];
yesno_items.add( "Yes/no question 1" );
# -----------------------------------

output_file csv_q = new output_file;
csv_q.open_append( output_name );
string subj_id = logfile.subject();

sub save_answer( string qid, string answer )
begin
    term.print_line( qid + ": " + answer );
    csv_q.print( subj_id + ";" + qid + ";" + answer + "\n" );
end;

# Instructions
info_txt.set_caption( instructions );
info_txt.redraw();
info_trial.present();

# Likert items
loop int i = 1 until i > likert_items.count()
begin
    question_txt.set_caption( likert_items[i] + "\n\n" + scale_anchors );
    question_txt.redraw();
    question_trial.present();
    save_answer( "L" + string(i), string( response_manager.last_response_data().code() ) );
    i = i + 1;
end;

# Free-text items (typed answer, confirmed with ENTER)
system_keyboard.set_delimiter( '\n' );
system_keyboard.set_log_keypresses( true );
loop int q = 1 until q > open_items.count()
begin
    open_question_txt.set_caption( open_items[q] + "\n\nType your answer and press ENTER" );
    open_question_txt.redraw();
    answer_txt.set_caption( "" );
    answer_txt.redraw();
    string typed = system_keyboard.get_input( open_question_pic, answer_txt );
    save_answer( "O" + string(q), typed );
    q = q + 1;
end;

# Yes/no items
loop int d = 1 until d > yesno_items.count()
begin
    question_txt.set_caption( yesno_items[d] + "\n\n1 = YES      2 = NO" );
    question_txt.redraw();
    question_trial.present();
    int code = response_manager.last_response_data().code();
    string ans = "NA";
    if code == 1 then ans = "YES"; elseif code == 2 then ans = "NO"; end;
    save_answer( "D" + string(d), ans );
    d = d + 1;
end;

# Goodbye
info_txt.set_caption( goodbye );
info_txt.redraw();
info_trial.present();
