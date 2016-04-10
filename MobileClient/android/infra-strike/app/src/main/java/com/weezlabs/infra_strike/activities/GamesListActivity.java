package com.weezlabs.infra_strike.activities;

import android.app.AlertDialog;
import android.bluetooth.BluetoothDevice;
import android.content.DialogInterface;
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
import com.weezlabs.infra_strike.datalayer.BtManager;
import com.weezlabs.infra_strike.datalayer.GameManager;
import com.weezlabs.infra_strike.dialogs.GetNameAndCodeDialog;
import com.weezlabs.infra_strike.models.Game;
import com.weezlabs.infra_strike.models.User;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import rx.functions.Action1;

public class GamesListActivity extends AppCompatActivity {
    private static final int REQUEST_BT_ENABLED = 100;
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

        if (BtManager.checkBtOrEnable(this, REQUEST_BT_ENABLED)) {
            final ArrayList<BluetoothDevice> devicesList = BtManager.getDevicesList();
            String devicesNames[] = new String[devicesList.size()];
            for (int i=0; i<devicesList.size(); i++) {
                devicesNames[i] = devicesList.get(i).getName();
            }

            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setTitle(R.string.select_bt_device)
                    .setItems(devicesNames, new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int which) {
                            GameManager.getInstance().setGameDevice(devicesList.get(which));
                        }
                    });
            builder.create().show();
        };
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case REQUEST_BT_ENABLED:
                BtManager.checkBtOrEnable(this, REQUEST_BT_ENABLED);
                break;
            default:
                super.onActivityResult(requestCode, resultCode, data);
        }
    }

    public void joinGame(final Game game) {
        if (!checkBtDevice()) {
            Snackbar.make(gamesListView, R.string.unable_to_connect_bt, Snackbar.LENGTH_LONG ).show();
            return;
        }

        AlertDialog dialog = new GetNameAndCodeDialog(this, GameManager.getInstance().getGameDevice(), new GetNameAndCodeDialog.OnFinishedListener() {
            @Override
            public void finished(String name, String code) {
                User me = new User();
                me.name = name;
                me.code = code;
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

            @Override
            public void canceled() {

            }
        });
        dialog.show();
    }

    private boolean checkBtDevice() {
        return GameManager.getInstance().getGameDevice() != null;
    }

    public void createGame(View sender) {
        if (!checkBtDevice()) {
            Snackbar.make(gamesListView, "Not Bluetooth device connected to play", Snackbar.LENGTH_LONG ).show();
            return;
        }

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
