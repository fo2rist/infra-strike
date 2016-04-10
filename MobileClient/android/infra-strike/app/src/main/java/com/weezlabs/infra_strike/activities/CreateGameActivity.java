package com.weezlabs.infra_strike.activities;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.RadioGroup;
import android.widget.Spinner;

import com.weezlabs.infra_strike.R;
import com.weezlabs.infra_strike.datalayer.GameManager;
import com.weezlabs.infra_strike.models.Game;

import rx.functions.Action1;

public class CreateGameActivity extends AppCompatActivity {

    private View rootView_;
    private View progressView;
    private EditText gameNameText;
    private EditText userNameText;
    private RadioGroup gameTypesRadioGroup;
    private Spinner respawnTimeSpinner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_game);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        rootView_ = findViewById(android.R.id.content);
        progressView = findViewById(R.id.progress);

        gameNameText = (EditText) findViewById(R.id.game_name_text);
        userNameText = (EditText) findViewById(R.id.user_name_text);
        gameTypesRadioGroup = (RadioGroup) findViewById(R.id.game_types_radio_group);
        respawnTimeSpinner = (Spinner) findViewById(R.id.respawn_time_spinner);

        //Populate respawn time spinner
        ArrayAdapter<Integer> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        adapter.add(15);
        adapter.add(30);
        adapter.add(60);
        respawnTimeSpinner.setAdapter(adapter);
    }

    public void createGame(View view) {
        //make all checks
        // Reset errors.
        gameNameText.setError(null);

        // Store values at the time of the login attempt.
        String gameName = gameNameText.getText().toString();
        String userName = userNameText.getText().toString();

        boolean cancel = false;
        View focusView = null;

        // Check for a valid email address.
        if (TextUtils.isEmpty(gameName)) {
            gameNameText.setError(getString(R.string.error_field_required));
            focusView = gameNameText;
            cancel = true;
        } else if (TextUtils.isEmpty(userName)) {
            userNameText.setError(getString(R.string.error_field_required));
            focusView = userNameText;
            cancel = true;
        }

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            focusView.requestFocus();
            return;
        }
        //create the game
        showProgress(true);
        String gameType;
        Integer respawnTime = (Integer) respawnTimeSpinner.getSelectedItem();
        switch (gameTypesRadioGroup.getCheckedRadioButtonId()) {
            case R.id.team_death_match_radiobutton:
                gameType = "teamdeathmatch";
                break;
            case R.id.check_point_radiobutton:
                gameType = "check point";
                break;
            case R.id.death_match_radiobutton:
            default:
                gameType = "deathmatch";
                break;

        }
        Game game = new Game(gameName, userName, gameType, "141", respawnTime);
        GameManager.getInstance().createGame(game).subscribe(
                new Action1<Game>() {
                    @Override
                    public void call(Game game) {
                        finish();
                        startActivity(new Intent(CreateGameActivity.this, GameActivity.class));
                    }
                },
                new Action1<Throwable>() {
                    @Override
                    public void call(Throwable throwable) {
                        showProgress(false);
                        Snackbar.make(rootView_, R.string.unable_to_create_game, Snackbar.LENGTH_LONG).show();
                    }
                }
        );

    }

    /**
     * Shows the progress UI and hides the login form.
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR2)
    private void showProgress(final boolean show) {
        // On Honeycomb MR2 we have the ViewPropertyAnimator APIs, which allow
        // for very easy animations. If available, use these APIs to fade-in
        // the progress spinner.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR2) {
            int shortAnimTime = getResources().getInteger(android.R.integer.config_shortAnimTime);

//            loginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
//            loginFormView.animate().setDuration(shortAnimTime).alpha(
//                    show ? 0 : 1).setListener(new AnimatorListenerAdapter() {
//                @Override
//                public void onAnimationEnd(Animator animation) {
//                    loginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
//                }
//            });

            progressView.setVisibility(show ? View.VISIBLE : View.GONE);
            progressView.animate().setDuration(shortAnimTime).alpha(
                    show ? 1 : 0).setListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    progressView.setVisibility(show ? View.VISIBLE : View.GONE);
                }
            });
        } else {
            // The ViewPropertyAnimator APIs are not available, so simply show
            // and hide the relevant UI components.
            progressView.setVisibility(show ? View.VISIBLE : View.GONE);
//            loginFormView.setVisibility(show ? View.GONE : View.VISIBLE);
        }
    }
}
