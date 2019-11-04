package com.geoff.broomball_app;

import java.util.HashMap;

/**
 * A class to represent all the data loaded from the broomball website.
 */
public class BroomballData
{
    private String year;
    private HashMap<String, Conference> conferences;

    public BroomballData()
    {
        conferences = new HashMap<>();
    }

    public void addConference(String id, Conference conference)
    {
        this.conferences.put(id, conference);
    }

    public String getYear()
    {
        return year;
    }

    public void setYear(String year)
    {
        this.year = year;
    }
}
