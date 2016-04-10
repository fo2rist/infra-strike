package com.weezlabs.infra_strike.activities;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.weezlabs.infra_strike.R;
import com.weezlabs.infra_strike.datalayer.BtManager;
import com.weezlabs.infra_strike.datalayer.GameManager;
import com.weezlabs.infra_strike.models.Game;
import com.weezlabs.infra_strike.models.User;

import java.util.Timer;
import java.util.TimerTask;

import rx.functions.Action1;

public class GameActivity extends AppCompatActivity {

    private ListView usersListView;
    private Timer timer_;

    private View leaveButton;
    private View startButton;
    private View stopButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        usersListView = (ListView) findViewById(R.id.users_list);
        leaveButton = findViewById(R.id.leave_game_button);
        startButton = findViewById(R.id.start_game_button);
        stopButton = findViewById(R.id.stop_game_button);

        BtManager.beginListenForData(GameManager.getInstance().getGameDevice(), new BtManager.OnGetDataListener() {
            @Override
            public void onGotData(String data) {
                GameManager.getInstance().reportShot(data)
                        .subscribe(
                                new Action1<Void>() {
                                    @Override
                                    public void call(Void aVoid) {

                                    }
                                },
                                new Action1<Throwable>() {
                                    @Override
                                    public void call(Throwable throwable) {

                                    }
                                }
                        );
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        timer_ = new Timer();
        timer_.schedule(getGameInfoTimerTask(), 100, 1000);
    }

    @Override
    protected void onPause() {
        super.onPause();
        timer_.cancel();
    }

    @Override
    protected void onStop() {
        BtManager.closeBT();
        super.onStop();
    }

    public void leaveGame(View sender) {
        GameManager.getInstance().leaveGame()
                .subscribe(
                        new Action1<Game>() {
                            @Override
                            public void call(Game game) {
                                finish();
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                            }
                        }
                );
    }

    public void startGame(View sender) {
        GameManager.getInstance().startGame()
                .subscribe(
                        new Action1<Void>() {
                            @Override
                            public void call(Void aVoid) {
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {

                            }
                        });
    }

    private void getGameInfo() {
        GameManager.getInstance().getGameInfo()
                .subscribe(
                        new Action1<Game>() {
                            @Override
                            public void call(Game game) {
                                updateUiByGameState(game);
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {

                            }
                        });
    }

    private void updateUiByGameState(Game game) {
        getSupportActionBar().setTitle(game.name);

        usersListView.setAdapter(new ArrayAdapter<User>(GameActivity.this,
                android.R.layout.simple_list_item_1,
                game.participants));

        switch (game.state) {
            case Game.GAME_STATE_FINISHED:
                leaveButton.setVisibility(View.GONE);
                startButton.setVisibility(View.GONE);
                stopButton.setVisibility(View.GONE);
                break;
            case Game.GAME_STATE_IN_PROGRESS:
                leaveButton.setVisibility(isGameOwner(game) ? View.GONE : View.VISIBLE);
                stopButton.setVisibility(isGameOwner(game) ? View.VISIBLE : View.GONE);
                startButton.setVisibility(View.GONE);
                break;
            case Game.GAME_STATE_PENDING:
                leaveButton.setVisibility(isGameOwner(game) ? View.GONE : View.VISIBLE);
                startButton.setVisibility(isGameOwner(game) ? View.VISIBLE : View.GONE);
                stopButton.setVisibility(isGameOwner(game) ? View.VISIBLE : View.GONE);
                break;
        }
    }

    private boolean isGameOwner(Game game) {
        return game.phone.equals(GameManager.getInstance().getUserPhone());
    }

    private TimerTask getGameInfoTimerTask() {
        return new TimerTask() {
            @Override
            public void run() {
                getGameInfo();
            } };
    }
}
