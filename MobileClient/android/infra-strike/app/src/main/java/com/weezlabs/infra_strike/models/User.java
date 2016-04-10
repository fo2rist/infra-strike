package com.weezlabs.infra_strike.models;

/**
 * Created by WeezLabs on 4/9/16.
 */
public class User {
    public String name;
    public String code;
    public String phone;
    public int frags;
    public int deaths;
    public boolean dead;

    @Override
    public String toString() {
        return name + "        Deaths: " + deaths + " Kills: " + frags + (dead ? " DEAD" : "");
    }
}
