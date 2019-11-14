package com.geoff.broomball_app;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

public class BroomballWebScraper
{
    private BroomballData data;

    public BroomballWebScraper()
    {
        data = new BroomballData();
    }

    public ArrayList<String> getYears() throws IOException
    {
        ArrayList<String> years = new ArrayList<>();
        Document page = Jsoup.connect("https://broomball.mtu.edu/teams/view").get();
        for (Element e : page.select("[name=season] > option"))
        {
            years.add(e.text());
        }

        return years;
    }

    /**
     * Method that runs through the process of scraping the entire broomball site
     *
     * @throws IOException If the scraper cannot connect to the site at any time
     */
    public void run(String year) throws IOException
    {
        Document currentWebPage = Jsoup.connect("https://broomball.mtu.edu/teams/view/" + year).get();

        this.data.setYear(year);

        // Select names of conferences and blocks containing division data
        Elements conferenceElements = currentWebPage.select("#main_content_container > h1");
        Elements divisionElements = currentWebPage.select("#main_content_container > blockquote");

        // Iterate through list of conferences
        for (int i = 0; i < conferenceElements.size(); i++)
        {
            Conference conference = new Conference();
            String conferenceName = conferenceElements.get(i).text();
//            System.out.println("Conference: " + conferenceName);

            Elements divisionHeaders = divisionElements.get(i).select("h1");
            Elements divisionTables = divisionElements.get(i).select("table > tbody");

            // Iterate through divisions (their headers and tables) within the conference
            for (int j = 0; j < divisionHeaders.size(); j++)
            {
                Division division = new Division();

                String divisionName = divisionHeaders.get(j).text();
//                System.out.println("\t" + divisionName);

                Elements tableRows = divisionTables.get(j).select("tr");
                int teamCount = tableRows.size() - 1;

                for (int k = 1; k < tableRows.size(); k++)
                {
                    String teamID;
                    String teamName;

                    Elements cells = tableRows.get(k).select("td");

                    String[] splitURL = cells.get(0).select("a").attr("href").split("/");
                    teamID = splitURL[splitURL.length - 1];

                    division.addTeamID(teamID);

                    teamName = cells.get(0).select("a").text();

                    data.addTeam(teamID, teamName);
                }

                conference.addDivision(divisionName, division);
            }

            data.addConference(conferenceName, conference);
        }

    }

    public BroomballData getData()
    {
        return data;
    }
}
