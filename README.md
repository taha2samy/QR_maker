
# 🎨 Custom Photo QR Generator

*A project in my "1 Year of DevOps & Software Studying" accountability journey.*

This is a Streamlit application that allows users to create customizable QR codes with the option of adding overlaying photos in the background and still getting an easily-recognized QR code. Most free tools online limit your ability to change shapes or add logos or at least hides it behind a paywall or a free trial; this project aims to provide that flexibility for free while maintaining high-quality output.

  
## 🧠 The Learning Journey (Why this matters)


This project's aim was a mix of  interest in QR code beautification in  python and a desire to apply Docker best practices I learnt with guidance from the Project "[Container Best Practices](https://devopsroadmap.io/projects/container-best-practices/)" in the Dynamic DevOps Roadmap.

* **Modern Package Management:** Switched to **`uv`** by Astral. I chose this because it is significantly faster than `pip` and provides a `uv.lock` file for 100% reproducible environments and more reusable than `requirement.txt` files.

* **Efficient Containerization:** I optimized my `Dockerfile` with Docker Best Practices in mind.



## 🛠️ Tech Stack


* **Core Logic:** [Segno](https://github.com/heuer/segno) (QR generation), [Pillow](https://www.google.com/search?q=https://python-pillow.org/) (Image processing).
* **Front-end:** [Streamlit](https://streamlit.io/).
- **Dependency Management**:  [uv](https://github.com/astral-sh/uv)
* **DevOps:** [Docker](https://www.docker.com/).



 
## 🚀 Running the App

  
### Prerequisites

  You just need to have Docker installed on your system.


 1. **Run the Container:**
The image currently resides on Dockerhub registry.

```bash

docker run -p 8501:8501 menna011/custom-qr-app:latest

```
2. **View the App:** Open `http://localhost:8501` in your browser.

## 🏗️ How I Applied Best Practices


* **Minimal Base Image:** Used `python:3.12-slim` to balance ease of use with a smaller security attack surface.

* **Deterministic Builds:** By using `uv sync --locked`, I ensure that the version of Streamlit I use today is the same one used in the container even at a much later time.

* **Minimal Created Image**: Not entirely satisfactory. Currently, the app image includes the `uv` binary, the `uv` cache, and potentially build-time dependencies that aren't needed at runtime. size: ~500MB; we can likely get it lower. 

* **Pin versions everywhere**: pinned the base image to `3.12` and, more importantly, we are using `uv sync --locked`. This pins every single sub-dependency via the `uv.lock` file.

  
## 🚀 What I Would Do Differently Next Time

-   **Implement a Multi-Stage Build:** Currently, the image is ~500MB because the build tools and caches stay inside the final image, which may not be a lot for a streamlit app, but too much for such a small app. I would like to try a multi-stage Dockerfile where Stage 1 builds the environment and Stage 2 only contains the final "distilled" Python environment and the app code.

-   **Automated CI/CD Pipeline:** Instead of manual building, I would set up GitHub Actions or Jenkins. Every time I push code, the image would be automatically built, scanned for vulnerabilities, and pushed to the registry.
    
-   **Secret Management:** Right now, the app is simple, but if I added a database or API keys, I would move away from `ENV` variables in the Dockerfile and use a secure secret manager or `.dockerignore` combined with encrypted secrets.
