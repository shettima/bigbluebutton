# Introduction #

With the update from BigBlueButton 0.81 to 0.9.0, we do not support upgrading a server in place. Instead, we recommend installing a fresh copy of Ubuntu 14.04 for BigBlueButton 0.9.0.

There are two ways of importing recordings from an old BigBlueButton server to a new one; they are described separately.



# Re-process raw recordings from an old server #

This is the recommended way of copying recordings, since the recordings will be rebuilt using newer versions of the recording software, enabling new features and fixing bugs that may have been present with the old version. The downside is that this can take a long time, and will use a lot of CPU on your new BigBlueButton server while you wait for the recordings to process.

If your old server has all of the original recording files in the `/var/bigbluebutton/recording/raw` directory, then you can transfer these files to the new server, for example with rsync:

This example rsync command could be run on the new server, and will copy the recording file from the old server.
```bash

rsync -rP root@bbb-0-81-server:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/
```

There are other ways of transferring these files; for example, you could create a tar archive of the `/var/bigbluebutton/recording/raw` directory, and copy it with scp, or use a shared NFS mount. Any method should work fine.

You will then need to fix the permissions on the newly copied recordings:
```bash

chown -R tomcat7:tomcat7 /var/bigbluebutton/recording/raw
```

And initiate the recording re-processing
```bash

bbb-record --rebuildall
```

The BigBlueButton server will automatically go through the recordings and rebuild and publish them. You can use the `bbb-record --watch` command to see the progress.

# Transfer existing published recordings from an old server #

If you want to do the minimum amount of work to quickly make your existing recordings available on the new BigBlueButton server, this is the suggested option.

First, you need to transfer the contents of the `/var/bigbluebutton/published` and `/var/bigbluebutton/unpublished` directories. In addition, to preserve the backup of the original raw media, you should transfer the contents of the `/var/bigbluebutton/recording/raw` directory.

Here is an example set of rsync commands that would accomplish this; run these on the new server to copy the files from the old server.
```bash

rsync -rP root@bbb-0-81-server:/var/bigbluebutton/published/ /var/bigbluebutton/published/
rsync -rP root@bbb-0-81-server:/var/bigbluebutton/unpublished/ /var/bigbluebutton/unpublished/
rsync -rP root@bbb-0-81-server:/var/bigbluebutton/recording/raw/ /var/bigbluebutton/recording/raw/
```

Other methods of transferring these files can also be used; for example, you could create a tar archive of each of the directories, and transfer it via scp, or use a shared NFS mount.

You will then need to fix the permissions on the newly copied recordings:
```bash

chown -R tomcat7:tomcat7 /var/bigbluebutton/published /var/bigbluebutton/unpublished /var/bigbluebutton/recording/raw
```

The transferred recordings should be immediately visible via the BigBlueButton recordings API.

## If you have BigBlueButton 0.80 recordings (slides format) ##

If you are transferring recordings from a BigBlueButton 0.80 server, they may have been done in an older recording format called "slides". In order to correctly play back these recordings on a new BigBlueButton server, you will have to install an additional package:

```bash

apt-get install bbb-playback-slides
```