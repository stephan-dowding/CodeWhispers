package branchFinder;

import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.storage.file.FileRepositoryBuilder;

public class Finder {
    public static void main(String[] args){
        System.out.println(findBranch());
    }

    public static String findBranch(){
        try {
            FileRepositoryBuilder builder = new FileRepositoryBuilder();
            Repository repository = builder.findGitDir().build();
            return repository.getBranch();
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
            return null;
        }
    }
}
