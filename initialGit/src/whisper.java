import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class whisper {
    private static String branch = branchFinder.Finder.findBranch();
    private static HttpClient httpClient = new DefaultHttpClient();

    public static void main(String[] args)
    {
        try {
            JsonObject element = getQuestion();

            int start = element.get("start").getAsInt();

            int end = start;

            postAnswer(end);


            System.out.println("Yipeeee! =D");

        }catch (Exception ex) {
            System.out.println(ex);
        } finally {
            httpClient.getConnectionManager().shutdown();
        }
    }

    private static JsonObject getQuestion() throws Exception {
        HttpGet get = new HttpGet("http://localhost:3000/challenge/question/" + branch);
        HttpResponse getResponse = httpClient.execute(get);

        if (getResponse.getStatusLine().getStatusCode() != 200)
            throw new Exception("Failed getting question :(");

        JsonParser parser = new JsonParser();
        return parser.parse(new InputStreamReader(getResponse.getEntity().getContent())).getAsJsonObject();
    }

    private static void postAnswer(int end) throws Exception {

        List<NameValuePair> params = new ArrayList<NameValuePair>(2);
        params.add(new BasicNameValuePair("end", String.valueOf(end)));

        HttpPost request = new HttpPost("http://localhost:3000/challenge/answer/" + branch);
        request.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
        HttpResponse postResponse = httpClient.execute(request);

        if (postResponse.getStatusLine().getStatusCode() != 200)
            throw new Exception("Got question wrong :(");
    }
}
