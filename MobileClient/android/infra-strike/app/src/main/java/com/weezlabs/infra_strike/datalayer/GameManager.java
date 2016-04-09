package com.weezlabs.infra_strike.datalayer;

import android.content.Context;
import android.content.SharedPreferences;

import com.weezlabs.infra_strike.models.Game;
import com.weezlabs.infra_strike.models.Account;
import com.weezlabs.infra_strike.models.User;
import com.weezlabs.infra_strike.network.InfraStrikeService;
import com.weezlabs.infra_strike.network.InfraStrikeServiceBuilder;

import java.util.List;

import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

/**
 * Created by WeezLabs on 4/9/16.
 */
public class GameManager {
    private static final String SHARED_PREFS_KEY = "Infra-Strike";
    private static final String UID_PREFS_KEY = "uid";
    private static final String PHONE_PREFS_KEY = "phone";


    private static GameManager instance;

    private InfraStrikeService service_ = null;
    private String uid_ = "";
    private String currentGame_ = "";
    private String userPhone_ = "";

    private Context context_;

    public static GameManager getInstance() {
        if (instance == null) {
            instance = new GameManager();
        }
        return instance;
    }

    private GameManager() {
        service_ = InfraStrikeServiceBuilder.build("http://10.10.42.42:5000/");
    }

    public void intialize(Context context) {
        context_ = context;
        restore();
    }

    public Observable<Account> signup(Account me) {
        return service_.signup(me)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread())
                .map(new Func1<Account, Account>() {
                    @Override
                    public Account call(Account user) {
                        uid_ = user.uid;
                        userPhone_ = user.phone;
                        save();
                        return user;
                    }
                });
    }

    public Observable<Game> createGame(Game game) {
        return service_.createGame(uid_, game)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread())
                .map(new Func1<Game, Game>() {
                    @Override
                    public Game call(Game game) {
                        currentGame_ = game.name;
                        return game;
                    }
                });
    }

    public Observable<Void> joinGame(final String gameName, User me) {
        return service_.joinGame(uid_, gameName, me)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread())
                .map(new Func1<Void, Void>() {
                    @Override
                    public Void call(Void aVoid) {
                        currentGame_ = gameName;
                        return null;
                    }
                });
    }

    public Observable<Void> startGame() {
        Game gameStartCommand = new Game();
        gameStartCommand.state = Game.GAME_STATE_IN_PROGRESS;

        return service_.startGame(uid_, currentGame_, gameStartCommand)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public Observable<Game> leaveGame() {
        if (currentGame_.isEmpty()) {
            return Observable.just(new Game());
        }

        return service_.leaveGame(uid_, currentGame_)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread())
                .map(new Func1<Game, Game>() {
                    @Override
                    public Game call(Game game) {
                        currentGame_ = "";
                        return game;
                    }
                });
    }

    public Observable<List<Game>> listGames() {
        return service_.listGames(uid_)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public Observable<Game> getGameInfo() {
        if (currentGame_.isEmpty()) {
            return Observable.just(new Game());
        }

        return service_.getGameInfo(uid_, currentGame_)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.newThread());
    }

    public void restore() {
        SharedPreferences preferences = context_.getSharedPreferences(SHARED_PREFS_KEY, Context.MODE_PRIVATE);
        uid_ = preferences.getString(UID_PREFS_KEY, "");
        userPhone_ = preferences.getString(PHONE_PREFS_KEY, "");
    }

    public void save() {
        SharedPreferences preferences = context_.getSharedPreferences(SHARED_PREFS_KEY, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(UID_PREFS_KEY, uid_);
        editor.putString(PHONE_PREFS_KEY, userPhone_);
        editor.commit();
    }

    /** @return empty string if not registered */
    public String getUserId() {
        return uid_;
    }

    public String getUserPhone() {
        return userPhone_;
    }

    public void logout() {
        uid_ = "";
        currentGame_ = "";
        userPhone_ = "";
        save();
    }
}
