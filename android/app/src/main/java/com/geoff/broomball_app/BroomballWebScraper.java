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

    /**
     * Method that runs through the process of scraping the entire broomball site
     * @return A BroomballData instance containing all the data
     * @throws IOException If the scraper cannot connect to the site at any time
     */
    public void run() throws IOException
    {
        System.out.println("Starting scrape.");

        Document divisionWebPage = Jsoup.connect("https://broomball.mtu.edu/teams/view").get(); // Load main webpage
        Elements yearsElements = divisionWebPage.select("[name=season] > option"); // Read list of years

        for (Element yearElement : yearsElements)
        {
            Year year = new Year();
            String yearText = yearElement.text();
            System.out.println("Year: " + yearText);

            Document currentWebPage = Jsoup.connect("https://broomball.mtu.edu/teams/view/" + yearText).get();

            // Select names of conferences and blocks containing division data
            Elements conferenceElements = currentWebPage.select("#main_content_container > h1");
            Elements divisionElements = currentWebPage.select("#main_content_container > blockquote");

            // Iterate through list of conferences
            for (int i = 0; i < conferenceElements.size(); i++)
            {
                Conference conference = new Conference();
                String conferenceName = conferenceElements.get(i).text();
                System.out.println("Conference: " + conferenceName);

                Elements divisionHeaders = divisionElements.get(i).select("h1");
                Elements divisionTables = divisionElements.get(i).select("table > tbody");

                // Iterate through divisions (their headers and tables) within the conference
                for (int j = 0; j < divisionHeaders.size(); j++)
                {
                    Division division = new Division();

                    String divisionName = divisionHeaders.get(j).text();
                    System.out.println("\t" + divisionName);

                    Elements tableRows = divisionTables.get(j).select("tr");
                    int teamCount = tableRows.size() - 1;

                    TeamScraperCoordinator coordinator = TeamScraperCoordinator.getInstance();
                    for (int k = 1; k < tableRows.size(); k++)
                    {
                        Team team = new Team();
                        String teamID;
                        String teamName;

                        Elements cells = tableRows.get(k).select("td");

                        String[] splitURL = cells.get(0).select("a").attr("href").split("/");
                        teamID = splitURL[splitURL.length - 1];

                        division.addTeamID(teamID);

                        teamName = cells.get(0).select("a").text();

                        if (teamName.endsWith("..."))
                        {
                            teamName =
                        }

                        team.setTeamName(teamName);
                        team.setWins(Integer.parseInt(cells.get(1).text()));
                        team.setLosses(Integer.parseInt(cells.get(2).text()));
                        team.setOvertimeLosses(Integer.parseInt(cells.get(3).text()));
                        team.setPoints(Integer.parseInt(cells.get(4).text()));
                        team.setGoalsFor(Integer.parseInt(cells.get(5).text()));
                        team.setGoalsAgainst(Integer.parseInt(cells.get(6).text()));
                        data.addTeam(teamID, team);
                    }

                    conference.addDivision(divisionName, division);
                }

                year.addConference(conferenceName, conference);
            }

            this.data.addYear(yearText, year);

            System.out.println();
        }
        // this.teamScraperCoordinator.finish();
        System.out.println("Scrape finished.");
    }

    public BroomballData getData()
    {
        return data;
    }
}
