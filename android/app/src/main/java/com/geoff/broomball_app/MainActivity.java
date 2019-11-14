package com.geoff.broomball_app;

import android.os.Bundle;

import com.google.gson.Gson;

import java.io.IOException;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity
{
    private static final String CHANNEL = "com.geoff.broomball_app/BroomballData";

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        BroomballWebScraper broomballWebScraper = new BroomballWebScraper();
        Gson gson = new Gson();

        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) ->
                {
                    if (call.method.equals("scrapeYear"))
                    {
                        if (call.hasArgument("year"))
                        {
                            String year = call.argument("year");
                            try
                            {
                                broomballWebScraper.run(year);
                                result.success(gson.toJson(broomballWebScraper.getData()));
                            } catch (IOException e)
                            {
                                result.error("UNAVAILABLE", "Broomball data not available", null);
                            }
                        }
                        else
                        {
                            result.error("UNAVAILABLE", "Broomball data not available", null);
                        }
                    }
                }
        );
    }
}
