package com.geoff.broomball_app;

import java.util.HashSet;

public class Division
{
    private HashSet<String> teamIDs;

    public Division()
    {
        teamIDs = new HashSet<>();
    }

    public void addTeamID(String id)
    {
        teamIDs.add(id);
    }
}
