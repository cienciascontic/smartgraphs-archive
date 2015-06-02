## SmartGraphs Retirement project


As per [these](https://www.pivotaltracker.com/story/show/85955588)
[PT Stories](https://www.pivotaltracker.com/story/show/85955790), the SmartGraphs authoring project will be retiring.

This repo contains archives of the activities, 'closed' signs, and project documentation.

#### Sub directories:

* `smartgraphs-closed` – the ["closed" sign](https://www.pivotaltracker.com/story/show/85955588) which will display when people try to visit the [SmartGraphs authoring site](smartgraphs-authoring.concord.org). This is published to an S3 bucket, and cloudfront CDN. For now this is living at http://smartgraphs-closed.concord.org. This should be changed when SmartGraphs authoring closes.
* `activity-archive` – an archive of the SmartGraphs activities from the SmartGraphs authoring website. Should include a script to regenerate these files, and publish to S3 / cloudfront.

#### Instructions

This project uses the [s3_website](https://github.com/laurilehmijoki/s3_website) gem to publish to AWS S3 buckets.  You will need to gather your Amazon S3 tokens and put them in to `./.env` files (which should not checked in to this repo.)

Both directories should have the following layout:

     ./folder
        - _site
          - project_files
        .env
        .env_sample
        s3_website.yml

1. install the s3_website gem `gem install s3_website`
2. Copy the `.env_sample` file to make a local `.env` that will automatically be used by s3_website to upload and sync content.
3. make changes in `_site/*` and use `s3_website push` to update the bucket and CDN.
4. To change configuration for any reason, edit `s3_website.yml` and then run `s3_website cfg apply`
5. This will update the website at `smartgraphs-closed.concord.org` as specified
in the file `smartgraphs-closed/s3_website.yml`. Read that file for more details.

#### activity-archive specific instructions

To rebuild the AWS S3 site of archived SmartGraphs activities:

0. optionally make changes to the index file `index.html.erb`
1. run `./slurp.rb` to copy activities from production website `to _site`
2. commit changes to this repo.
3. push changes to S3 `s3_website push` from within the `activity-archive` folder
4. this will update the site at http://smartgraphs-activity-arch.concord.org/

NB: This does not copy the resources required for the activities (image &etc.)
TBD.

#### The Amazon AMI for SmartGraphs authoring

A private AMI was created ami-abb854c0 of the authoring system before the latest
bug fixes (related to copying) were deployed. As soon as new changes go into
production a new private AMI can be created.

The AMI's are private, because they include database credentials at the moment.
If we want to create a public AMI, that work remains to be completed.
(Idea: We could create a public AMI using sqllite in future.)
