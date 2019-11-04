package com.geoff.broomball_app.api;

import com.google.gson.Gson;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.IOException;

public class BroomballAPI
{
    private Gson gson;

    public BroomballAPI()
    {
        gson = new Gson();
    }

    public APIPlayer getPlayer(String id)
    {
        try
        {
            Document data = Jsoup.connect("https://www.broomball.mtu.edu/api/player/id/" + id + "/key/0").ignoreContentType(true).get();
            APIPlayer player = gson.fromJson(data.text(), APIPlayer.class);
            return player;
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public APITeam getTeam(String id)
    {
        try
        {
            Document data = Jsoup.connect("https://www.broomball.mtu.edu/api/team/id/" + id + "/key/0").ignoreContentType(true).get();
            APITeam team = gson.fromJson(data.text(), APITeam.class);
            return team;
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        return null;
    }
}
