# Generic mouse-driven Visual Analogue Scale (VAS) for Neurobehavioral Systems Presentation
# The participant moves a cursor along a horizontal line with the mouse and clicks to confirm.
# Any number of VAS items can be presented in sequence: edit the arrays in the PCL section.

scenario = "VAS template";
active_buttons = 1;          # left mouse button confirms the rating
button_codes = 1;
default_font = "Arial";
default_font_size = 5;
max_y = 100;                 # screen-independent units: the screen is 200 units high
default_background_color = 255,255,255;
default_text_color = 0,0,0;

begin;

# --- Instructions / goodbye screen ---
text { caption = ""; font_size = 6; max_text_width = 160; } info_txt;
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

# --- VAS screen (the order of the parts matters: the cursor is part 3) ---
text { caption = " "; font_size = 7; max_text_width = 160; } question_txt;
text { caption = " "; font_size = 4; } left_txt;
text { caption = " "; font_size = 4; } right_txt;
picture {
    text question_txt;
    x = 0; y = 35;
    box { color = 100,100,100; width = 140; height = 0.5; };   # scale line
    x = 0; y = 0;
    box { color = 255,0,0; width = 1; height = 6; };          # cursor
    x = 0; y = 0;
    text left_txt;
    x = -85; y = 0;
    text right_txt;
    x = 85; y = 0;
} vas_pic;

begin_pcl;

# ---------- CONFIGURATION ----------
string output_name = "vas_results.csv";

string instructions = parameter_manager.get_string( "instructions", "Instructions" );
string goodbye      = parameter_manager.get_string( "end", "Thank you" );

double LINE_WIDTH = 140.0; # must match the width of the scale line (screen units)
int MOUSE_RANGE = 2400;    # mouse movement needed to cross the whole line (sensitivity)
int CURSOR_PART  = 3;      # position of the cursor among the parts of vas_pic
double SCORE_MAX = 100.0;  # rating range: 0 to SCORE_MAX

# One entry per VAS: question, left anchor, right anchor, label used in the CSV
array<string> questions[0];
array<string> left_anchors[0];
array<string> right_anchors[0];
array<string> labels[0];

questions.add( "VAS question 1" ); left_anchors.add( "Not at all" ); right_anchors.add( "Extremely" ); labels.add( "VAS1" );
questions.add( "VAS question 2" ); left_anchors.add( "Not at all" ); right_anchors.add( "Extremely" ); labels.add( "VAS2" );
# -----------------------------------

output_file csv_file = new output_file;
csv_file.open_append( output_name );
string subj_id = logfile.subject();

# Instructions
info_txt.set_caption( instructions );
info_txt.redraw();
info_trial.present();

# Mouse limited to the length of the scale
mouse mse = response_manager.get_mouse( 1 );
mse.set_min_max( 1, -MOUSE_RANGE / 2, MOUSE_RANGE / 2 );

loop int i = 1 until i > questions.count()
begin
    question_txt.set_caption( questions[i] );   question_txt.redraw();
    left_txt.set_caption( left_anchors[i] );    left_txt.redraw();
    right_txt.set_caption( right_anchors[i] );  right_txt.redraw();

    # Cursor back to the centre, so the previous rating does not carry over
    mse.set_xy( 0, 0 );

    # Count only the clicks made after this VAS appears
    int start_responses = response_manager.total_response_count();

    int xpos = 0;
    loop bool done = false until done
    begin
        mse.poll();
        xpos = int( mse.x_position() );
        vas_pic.set_part_x( CURSOR_PART, double(xpos) / double(MOUSE_RANGE) * LINE_WIDTH );
        vas_pic.present();
        if response_manager.total_response_count() > start_responses then
            done = true;
        end;
    end;

    # Cursor position converted to 0 - SCORE_MAX
    double rating = ( double(xpos) + MOUSE_RANGE / 2.0 ) / double(MOUSE_RANGE) * SCORE_MAX;

    term.print_line( labels[i] + " = " + string( int(rating) ) );
    logfile.add_event_entry( labels[i] + "=" + string( int(rating) ) );
    csv_file.print( subj_id + ";" + labels[i] + ";" + string( int(rating) ) + "\n" );

    i = i + 1;
end;

# Goodbye
info_txt.set_caption( goodbye );
info_txt.redraw();
info_trial.present();

csv_file.close();
