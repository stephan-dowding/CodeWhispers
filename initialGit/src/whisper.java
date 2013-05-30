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
    public static void main(String[] args)
    {
        String branch = branchFinder.Finder.findBranch();
        HttpClient httpClient = new DefaultHttpClient();

        try {
            HttpGet get = new HttpGet("http://localhost:3000/challenge/question/" + branch);
            HttpResponse getResponse = httpClient.execute(get);

            if (getResponse.getStatusLine().getStatusCode() != 200)
                throw new Exception("Failed getting question :(");

            JsonParser parser = new JsonParser();
            JsonObject element = parser.parse(new InputStreamReader(getResponse.getEntity().getContent())).getAsJsonObject();

            int s = element.get("start").getAsInt();
            String i = element.get("instructions").getAsString();

            int answer = s + i.length();

            HttpPost request = new HttpPost("http://localhost:3000/challenge/answer/" + branch);
            List<NameValuePair> params = new ArrayList<NameValuePair>(2);
            params.add(new BasicNameValuePair("end", String.valueOf(answer)));
            request.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
            HttpResponse postResponse = httpClient.execute(request);

            if (postResponse.getStatusLine().getStatusCode() != 200)
                throw new Exception("Got question wrong :(");


            System.out.println("Yipeeee! =D");
            // handle response here...
        }catch (Exception ex) {
            System.out.println(ex);
        } finally {
            httpClient.getConnectionManager().shutdown();
        }
    }
}
