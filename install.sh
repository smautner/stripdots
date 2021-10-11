for i in $(ls packages); do
        targetfolder=~/.$i
        mkdir -p $targetfolder
        for sub in $(ls $(pwd)/packages/$i); do
                unlink $targetfolder/$sub
                rm -rf $targetfolder/$sub
                ln -s -f $(pwd)/packages/$i/$sub $targetfolder/$sub
        done
done

for i in $(ls direct); do
        unlink ~/.$i
        ln -s -f $(pwd)/direct/$i ~/.$i
done


