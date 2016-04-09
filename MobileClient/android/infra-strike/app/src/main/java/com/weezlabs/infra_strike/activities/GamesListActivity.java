package com.weezlabs.infra_strike.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.weezlabs.infra_strike.R;
import com.weezlabs.infra_strike.datalayer.GameManager;
import com.weezlabs.infra_strike.models.Game;
import com.weezlabs.infra_strike.models.User;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import rx.functions.Action1;

public class GamesListActivity extends AppCompatActivity {

    private ListView gamesListView;
    private Timer timer_;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_games_list);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        gamesListView = (ListView) findViewById(R.id.games_list);
        gamesListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Game game = (Game) gamesListView.getItemAtPosition(position);
                joinGame(game);
            }
        });

    }

    @Override
    protected void onResume() {
        super.onResume();
        timer_ = new Timer();
        timer_.schedule(getGamesTimerTask(), 100, 1000);
    }

    @Override
    protected void onPause() {
        super.onPause();
        timer_.cancel();
    }

    public void joinGame(Game game) {
        User me = new User();
        me.name = "Vasia";
        me.code = "144";
        GameManager.getInstance().joinGame(game.name, me)
                .subscribe(
                        new Action1<Void>() {
                        @Override
                            public void call(Void aVoid) {
                                startActivity(new Intent(GamesListActivity.this, GameActivity.class));
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                                Snackbar.make(GamesListActivity.this.gamesListView, R.string.unable_to_join_game, Snackbar.LENGTH_LONG).show();
                            }
                        });

    }

    public void createGame(View sender) {
        startActivity(new Intent(this, CreateGameActivity.class));
    }

    public void logout(View view) {
        GameManager.getInstance().logout();
        finish();
        startActivity(new Intent(this, LoginActivity.class));
    }

    private void getGamesList() {
        GameManager.getInstance().listGames()
                .subscribe(
                        new Action1<List<Game>>() {
                            @Override
                            public void call(List<Game> games) {
                                gamesListView.setAdapter(new ArrayAdapter<Game>(GamesListActivity.this,
                                        android.R.layout.simple_list_item_1,
                                        games));
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                                gamesListView.setAdapter(null);
                            }
                        });
    }

    private TimerTask getGamesTimerTask() {
        return new TimerTask() {
            @Override
            public void run() {
                getGamesList();
            } };
    }
}
