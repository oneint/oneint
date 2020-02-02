# OneInt - Create and manage GDPR/CCPA data-subject requests with ease.

![OneInt](app/assets/images/oneint.gif)

## Summary
OneInt - Data Privacy Platform that helps create and manage DSR requests from end-users.

**If you have ANY questions regarding the platform, please email us at team@oneint.io**

[Why OneInt?](#why-oneint)

[Installation](#installation)

[Contributions](#contributions)

[How it works?](#how-it-works)

[Roadmap](#roadmap)

[Support](#support)

## Why OneInt?
If you need to comply with GDPR/CCPA, you will likely need to address consumers requests to access or delete data. Our goal is to make this process less painful and more transparent. If you're building any application/service, you probably use at least several third-party services like(Mixpanel, customer.io, Appsflyer, etc), that means that you need to pull/erase the consumers data from these services. OneInt connects you to these third-party providers via simple API.

| Without OneInt  | With OneInt |
| --------------- | ----------- |
| ![Without OneInt](app/assets/images/oneint-Page-1.png)  | ![With OneInt](app/assets/images/oneint-Page-2.png)  |

## Installation

### Tech Stack
 - Ruby
 - Rails
 - MySql
 - Sidekiq for background jobs
 - Redis

### Installation instructions
It's v0 and we're planning to add Packages/Docker/etc in the future versions but for now you can install it from source.
OneInt is a Rails application, if you're not familiar how to run the rails app - let us know and we'll be more than happy to help with the installation.

### Configuration/ENV variables
In the root of the repo you can find .env.example file. Copy it and save as .env file in the root of the app.
You will need manually set the following variables before launching the app.

| ENV variable               | Meaning/Value                  |
| -------------------------- | ------------------------------ |
| SECRET_KEY_FOR_ENCRYPTION  | 32-byte Secret key that will be used to encrypt API keys keys before saving to DB |
| SIDEKIQ_USERNAME           | Sidekiq username to access sidekiq admin panel                                    |
| SIDEKIQ_PASSWORD           | Sidekiq password to access sidekiq admin panle                                    |
| BASE_URL                   | URL where you host the application. For example https://oneint.io                 |
| STORAGE_TYPE               | 'memory' OR 'file_system' OR 's3'(default). For file storage                      |
| STORAGE_AWS_REGION         | 'us-east-1' is a default one                                                      |
| STORAGE_S3_BUCKET          | Name of the bucket where you want to store files                                  |
| AWS_ACCESS_KEY_ID          | Your AWS access key                                                               |
| AWS_SECRET_ACCESS_KEY      | Your AWS secret access key                                                        |

## How it works?
There are two ways how you can create a request in OneInt: API and through the UI.
Once OneInt receives a request it will automatically send the request to all integrations you've created.
If you added a custom webhook integration, OneInt will send a JWT that you can decode with your public key using ES384 algorithm.

If you need help installing or integrating with OneInt, please shoot us an email: **team@oneint.io**.
**More detailed documentation is coming.**

## Roadmap
We have a list of features we want to build but also we need your feedback and requests. (team@oneint.io)
Some of the features we're going to build in the next versions:
 - Yes, we're planning to add integrations with other popular services.
 - Verification of the requests
 - Privacy center

## Contributions
Feel free to submit a PR if you want to Contribute to the project

## Support
If you need a Support or any additional features - let us know (team@oneint.io)
