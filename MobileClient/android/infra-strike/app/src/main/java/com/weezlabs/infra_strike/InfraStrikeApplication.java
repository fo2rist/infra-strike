package com.weezlabs.infra_strike;

import android.app.Application;

import com.weezlabs.infra_strike.datalayer.GameManager;

/**
 * Created by WeezLabs on 4/9/16.
 */
public class InfraStrikeApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        GameManager.getInstance().intialize(this);
    }
}
