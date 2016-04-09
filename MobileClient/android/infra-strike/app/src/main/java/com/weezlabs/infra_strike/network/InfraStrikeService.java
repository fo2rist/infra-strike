package com.weezlabs.infra_strike.network;

import com.weezlabs.infra_strike.models.Game;
import com.weezlabs.infra_strike.models.Account;
import com.weezlabs.infra_strike.models.User;

import java.util.List;

import retrofit.http.Body;
import retrofit.http.DELETE;
import retrofit.http.GET;
import retrofit.http.Header;
import retrofit.http.POST;
import retrofit.http.PUT;
import retrofit.http.Path;
import rx.Observable;

/**
 * Created by WeezLabs on 4/9/16.
 */
public interface InfraStrikeService {
    @POST("users")
    Observable<Account> signup(@Body Account me);

    @POST("games")
    Observable<Game> createGame(@Header("uid") String userid, @Body Game game);

    @POST("games/{gameName}/participants ")
    Observable<Void> joinGame(@Header("uid") String userid, @Path("gameName") String gameName, @Body User me);

    @PUT("games/{gameName}")
    Observable<Void> startGame(@Header("uid") String userid, @Path("gameName") String gameName, @Body Game game);

    @DELETE("games/{gameName}/participants")
    Observable<Game> leaveGame(@Header("uid") String userid, @Path("gameName") String gameName);

    @GET("games")
    Observable<List<Game>> listGames(@Header("uid") String userid);

    @GET("games/{gameName}")
    Observable<Game> getGameInfo(@Header("uid") String userid, @Path("gameName") String gameName);

    @POST("games/{gameName}/shots")
    Observable<Void> reportShot(@Header("uid") String userid, @Path("gameName") String gameName);


    //temp before we get push notifications
    Observable<Void> getGameStatus();
}
