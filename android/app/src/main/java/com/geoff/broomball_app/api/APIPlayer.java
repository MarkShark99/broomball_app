package api;

import java.util.ArrayList;

public class APIPlayer
{
    private APIPlayerInfo info;
    private ArrayList<APIPlayerGame> stats;

    private String error = null;

    public APIPlayerInfo getInfo()
    {
        return info;
    }

    public ArrayList<APIPlayerGame> getStats()
    {
        return stats;
    }

    public boolean verify()
    {
        return error == null;
    }
}
