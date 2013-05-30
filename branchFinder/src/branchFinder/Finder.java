package branchFinder;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Finder {
    public static void main(String[] args){
        System.out.println(findBranch());
    }

    public static String findBranch(){
        String branch = null;
        try {
            Process process = new ProcessBuilder("git", "branch").start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while((line = reader.readLine()) != null){
                if (line.startsWith("* ")){
                    branch = line.substring(2);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }
        return branch;
    }
}
