package com.geoff.broomball_app.api;

public class APITeamGame
{
    private String game_id;
    private String played;
    private String otl;
    private String video_url;
    private String rink_name;
    private String canceled;
    private String home_team_id;
    private String home_team_name;
    private String home_goals;
    private String away_team_id;
    private String away_team_name;
    private String away_goals;
    private String start_time;
    private String rink_id;
    private String forfeited;

    public String getGame_id()
    {
        return game_id;
    }

    public String getPlayed()
    {
        return played;
    }

    public String getOtl()
    {
        return otl;
    }

    public String getVideo_url()
    {
        return video_url;
    }

    public String getRink_name()
    {
        return rink_name;
    }

    public String getCanceled()
    {
        return canceled;
    }

    public String getHome_team_id()
    {
        return home_team_id;
    }

    public String getHome_team_name()
    {
        return home_team_name;
    }

    public String getHome_goals()
    {
        return home_goals;
    }

    public String getAway_team_id()
    {
        return away_team_id;
    }

    public String getAway_team_name()
    {
        return away_team_name;
    }

    public String getAway_goals()
    {
        return away_goals;
    }

    public String getStart_time()
    {
        return start_time;
    }

    public String getRink_id()
    {
        return rink_id;
    }

    public String getForfeited()
    {
        return forfeited;
    }
}
