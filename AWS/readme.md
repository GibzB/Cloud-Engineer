# Securing and Delivering S3 Content via CloudFront

In this tutorial, we will walk you through securing your Amazon S3 bucket and delivering content using Amazon CloudFront, AWS's content delivery network (CDN). We’ll cover how to:

1. **Create and organize an S3 bucket** for storing objects.
2. **Upload content** to the bucket.
3. **Test public access** for your objects.
4. **Secure your S3 bucket** using CloudFront and Origin Access Control (OAC).
5. **Configure CloudFront** to handle access to your objects via a CDN.
6. **Replicate S3 objects across regions** for enhanced availability (optional).

By the end of this tutorial, you’ll have a fully secured S3 bucket, a CloudFront distribution delivering content securely, and optionally, a cross-region replication setup for your S3 data.

## Task 1: Create an S3 Bucket and Configure It for Content Storage

### 1.1: Create the S3 Bucket

Start by creating an S3 bucket to store your objects. To create a bucket in Amazon S3, follow these steps:

* **Sign in** to the AWS Management Console.
* Go to the **S3 Console** and click  **Create bucket** .
* Choose a **unique name** for the bucket (e.g., `LabBucket`).
* Select a region (ensure it's the region closest to your target audience).
* Leave the other default settings (such as Block Public Access) enabled for now.
* Click  **Create bucket** .

## Task 2: Upload Content to the S3 Bucket

### 2.1: Create a Folder in Your Bucket

Organize your objects by creating a folder within your S3 bucket:

* Open the  **S3 Console** .
* Navigate to your  **LabBucket** .
* Under the **Objects** tab, click  **Create folder** .
* Name the folder `CachedObjects`.
* Click  **Create folder** .

### 2.2: Upload an Object

Next, upload an object (e.g., `logo.png`) to test public access:

* Download the `logo.png` file to your local machine.
* In the S3 console, click on the `CachedObjects` folder.
* Click  **Upload** , select  **Add files** , and choose the `logo.png` file.
* Click  **Upload** . Once uploaded, you’ll see a confirmation message.

## Task 3: Test Public Access to Your Object

### 3.1: Check the Object’s URL

To verify that the object is publicly accessible:

* Click the **logo.png** file in the **CachedObjects** folder.
* Copy the **Object URL** from the details page and open it in a new browser tab.
* You should see the image displayed in your browser.

### 3.2: Understand the URL Format

The URL will be in this format:

```
https://LabBucket.s3.amazonaws.com/CachedObjects/logo.png
```

This URL directly links to your S3 object, but this public access can be restricted later.

## Task 4: Secure the Bucket with Amazon CloudFront

### 4.1: Set Up CloudFront to Serve Content Securely

In this task, we’ll configure CloudFront to serve content from your S3 bucket while restricting direct access from S3. Here’s how you can do that:

1. **Create or use an existing CloudFront Distribution:**

   * Go to the  **CloudFront Console** .
   * If you already have a distribution, select it. Otherwise, click **Create Distribution** and choose  **Web** .
   * Choose your S3 bucket as the origin. This will be the source of your content.
2. **Create a New Origin Access Control (OAC):**

   * When creating or editing the CloudFront distribution, go to the **Origins** tab.
   * Click  **Create Origin** , select your S3 bucket, and configure **Origin Access Control** (recommended).
   * Choose **Create new OAC** and leave the default settings.
   * Click **Create** to finish adding the origin.
3. **Update the S3 Bucket Policy to Allow CloudFront Access:**

   * Open the  **S3 Console** , go to  **LabBucket** , and navigate to the **Permissions** tab.
   * In the **Bucket Policy** section, click  **Edit** .
   * Add the following policy JSON to allow CloudFront to access your S3 objects. Make sure to replace `RESOURCE_ARN` and `CLOUDFRONT_DISTRIBUTION_ARN` with your actual values:

   ```
   {
       "Version": "2012-10-17",
       "Statement": {
           "Sid": "AllowCloudFrontServicePrincipalReadOnly",
           "Effect": "Allow",
           "Principal": {
               "Service": "cloudfront.amazonaws.com"
           },
           "Action": [
               "s3:GetObject",
               "s3:GetObjectVersion"
           ],
           "Resource": "arn:aws:s3:::LabBucket/*",
           "Condition": {
               "StringEquals": {
                   "AWS:SourceArn": "arn:aws:cloudfront::123456789:distribution/E3LU8VQUNZACBE"
               }
           }
       }
   }

   ```

   * Save the policy.
4. **Enable Public Access Blockers:**

   * Go to the **Permissions** tab and locate the **Block Public Access** section.
   * Click  **Edit** , enable  **Block all public access** , and confirm the change by entering `confirm`.

## Task 5: Create a CloudFront Behavior to Serve Content from S3

### 5.1: Create a New Cache Behavior

To ensure CloudFront serves the object only from your S3 bucket and does not allow public access to the object directly via S3 URLs:

1. In the  **CloudFront Console** , go to the **Behaviors** tab.
2. Click  **Create behavior** .
3. In the  **Path pattern** , enter `CachedObjects/*.png` to specify that CloudFront will only serve `.png` objects.
4. Set **Origin** to your S3 bucket origin.
5. In  **Cache key and origin requests** , ensure that the **Cache policy and origin request policy** are set to  **CachingOptimized** .
6. Save the behavior.

## Task 6: Test Direct Access to the S3 Object

Now, let’s test if direct access to your S3 object is still possible after configuring CloudFront.

1. Go to the **S3 Console** and select  **LabBucket** .
2. Open the **CachedObjects** folder and click on the `logo.png` file.
3. Copy the **Object URL** and paste it in a new browser tab.

You should see an **Access Denied** error. This is expected, as the bucket policy now only allows access via CloudFront.

## Task 7: Test Access via CloudFront

### 7.1: Access the Object Using CloudFront

1. Go to the  **CloudFront Console** , and find your  **CloudFront Distribution DNS** .
2. Append `/CachedObjects/logo.png` to the CloudFront DNS and enter it into your browser’s address bar. For example:
   <pre class="!overflow-visible"><div class="contain-inline-size rounded-md border-[0.5px] border-token-border-medium relative bg-token-sidebar-surface-primary dark:bg-gray-950" bis_skin_checked="1"><div class="flex items-center text-token-text-secondary px-4 py-2 text-xs font-sans justify-between rounded-t-md h-9 bg-token-sidebar-surface-primary dark:bg-token-main-surface-secondary select-none" bis_skin_checked="1">bash</div><div class="sticky top-9 md:top-[5.75rem]" bis_skin_checked="1"><div class="absolute bottom-0 right-2 flex h-9 items-center" bis_skin_checked="1"><div class="flex items-center rounded bg-token-sidebar-surface-primary px-2 font-sans text-xs text-token-text-secondary dark:bg-token-main-surface-secondary" bis_skin_checked="1"><span class="" data-state="closed"><button class="flex gap-1 items-center select-none py-1"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="icon-sm"><path fill-rule="evenodd" clip-rule="evenodd" d="M7 5C7 3.34315 8.34315 2 10 2H19C20.6569 2 22 3.34315 22 5V14C22 15.6569 20.6569 17 19 17H17V19C17 20.6569 15.6569 22 14 22H5C3.34315 22 2 20.6569 2 19V10C2 8.34315 3.34315 7 5 7H7V5ZM9 7H14C15.6569 7 17 8.34315 17 10V15H19C19.5523 15 20 14.5523 20 14V5C20 4.44772 19.5523 4 19 4H10C9.44772 4 9 4.44772 9 5V7ZM5 9C4.44772 9 4 9.44772 4 10V19C4 19.5523 4.44772 20 5 20H14C14.5523 20 15 19.5523 15 19V10C15 9.44772 14.5523 9 14 9H5Z" fill="currentColor"></path></svg>Copy code</button></span></div></div></div><div class="overflow-y-auto p-4" dir="ltr" bis_skin_checked="1"><code class="!whitespace-pre hljs language-bash">d1234567890abc.cloudfront.net/CachedObjects/logo.png
   </code></div></div></pre>
3. You should see the image served via CloudFront.

If the CloudFront URL redirects to the S3 URL or you encounter issues, **check the distribution status** in the CloudFront Console. Wait for the distribution to propagate fully and try again.

## Optional Task 8: Set Up Cross-Region Replication

### 8.1: Enable Versioning on Your Source Bucket

Before setting up cross-region replication, you need to enable **versioning** on both the source and destination S3 buckets.

1. In the  **S3 Console** , go to  **LabBucket** .
2. Under the **Properties** tab, find **Bucket Versioning** and enable it.

### 8.2: Create a Destination Bucket

1. Create a new bucket in a different region (e.g.,  **DestinationBucket** ).
2. Enable versioning and uncheck **Block all public access** if you want to test replication with public URLs.

### 8.3: Set Up Replication Rules

1. In the  **LabBucket** , go to the **Management** tab.
2. Create a **Replication rule** and set **LabBucket** as the source.
3. Select the **DestinationBucket** as the destination.
4. Create a new **IAM role** for replication and save the rule.

### 8.4: Verify Replication

Upload a new object (e.g., `logo2.png`) to  **LabBucket** . Once the object is uploaded, you should see it appear in the **DestinationBucket** after the replication status changes from **PENDING** to  **COMPLETED** .

## Conclusion

In this guide, we’ve demonstrated how to:

1. **Create an S3 bucket** , organize objects, and upload files.
2. **Secure the S3 bucket** with CloudFront to ensure content is delivered securely.
3. **Test public access** to objects and restrict it to CloudFront using Origin Access Control (OAC).
4. Optionally, **set up cross-region replication** for disaster recovery and improved availability.

With these steps, you can ensure your content is delivered efficiently via CloudFront while maintaining security through access control. You can also take advantage of cross-region replication to enhance your application’s availability and resilience.
