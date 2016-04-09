package com.weezlabs.infra_strike.models;

import java.util.List;

/**
 * Created by WeezLabs on 4/9/16.
 */
public class Game {
    public static final String GAME_STATE_PENDING = "pending";
    public static final String GAME_STATE_IN_PROGRESS = "in progress";
    public static final String GAME_STATE_FINISHED = "finished";

    public String name;
    public String creatorName;
    public String phone;
    public String mode;
    public String code;
    public int respawnSeconds;
    public String state;
    public List<User> participants;

    public Game() {

    }

    public Game(String name, String creatorName, String mode, String code, int respawnSeconds) {
        this.name = name;
        this.creatorName = creatorName;
        this.mode = mode;
        this.code = code;
        this.respawnSeconds = respawnSeconds;
    }

    @Override
    public String toString() {
        return name + " (" + mode + ")";
    }
}
