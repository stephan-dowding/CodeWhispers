package core.web;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import core.git.Util;
import core.runner.Runner;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;

import java.io.InputStreamReader;

public class ChallengeServer {

    private static HttpClient httpClient = HttpClientBuilder.create().build();
    private static final Gson gson = new GsonBuilder().disableHtmlEscaping().create();
    private static final String CODE_WHISPER_HOST = "codewhispers.org";

    public static JsonObject getQuestion() throws Exception {
        HttpGet get = new HttpGet(String.format("http://"+ CODE_WHISPER_HOST +"/challenge/question/%s", Util.branchName()));

        get.setConfig(noRedirect());
        HttpResponse getResponse = httpClient.execute(get);

        if (getResponse.getStatusLine().getStatusCode() != 200)
            throw new Exception("Failed getting question :(");

        JsonParser parser = new JsonParser();
        return parser.parse(new InputStreamReader(getResponse.getEntity().getContent())).getAsJsonObject();
    }

    public static void postAnswer(JsonObject answer) throws Exception {
        HttpPost request = new HttpPost(String.format("http://"+ CODE_WHISPER_HOST +"/challenge/answer/%s", Util.branchName()));

        request.setConfig(noRedirect());

        StringEntity params =new StringEntity(answer.toString());
        request.addHeader("content-type", "application/json");
        request.addHeader("accept", "application/json");
        request.setEntity(params);

        HttpResponse postResponse = httpClient.execute(request);
        int statusCode = postResponse.getStatusLine().getStatusCode();
        String responseBody = EntityUtils.toString(postResponse.getEntity());
        switch (statusCode) {
            case(HttpStatus.SC_OK) :
                System.out.println("Yay! Got it right!!! =D");
                break;
            case(HttpStatus.SC_SEE_OTHER) :
                System.out.println("Got it right, but do another...");
                Runner.doChallenge();
                break;
            case(418) :
                System.out.println("Boo hoo hoo.... Got it wrong!!!");
                System.out.println(responseBody);
                System.exit(1);

        }
    }


    private static RequestConfig noRedirect(){
        return RequestConfig.custom().setRedirectsEnabled(false).build();
    }
}
