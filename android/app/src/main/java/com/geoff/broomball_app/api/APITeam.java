package com.geoff.broomball_app.api;

import java.util.ArrayList;
import java.util.HashMap;

public class APITeam
{
    private APITeamInfo info;

    private HashMap<String, APITeamRosterPlayer> roster;
    private ArrayList<APITeamGame> schedule;

    String error = null;

    public boolean verify()
    {
        return error == null;
    }

    public APITeamInfo getInfo()
    {
        return info;
    }

    public HashMap<String, APITeamRosterPlayer> getRoster()
    {
        return roster;
    }

    public ArrayList<APITeamGame> getSchedule()
    {
        return schedule;
    }
}
