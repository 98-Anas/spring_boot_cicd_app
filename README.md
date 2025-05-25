# **Spring Boot CI/CD with DevSecOps on GitLab**  
![GitLab CI/CD](https://img.shields.io/badge/GitLab-CI/CD-orange)  
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-brightgreen)  
![DevSecOps](https://img.shields.io/badge/DevSecOps-Enabled-success)

---

## **Overview**  
This project implements a secure and automated CI/CD pipeline for a Spring Boot microservice using GitLab CI/CD, adhering to modern DevSecOps practices. It streamlines the entire development-to-deployment lifecycle by automating build, testing, security scanning, and deployment processes. Security is integrated at every stage of the pipeline to ensure a safe and reliable software delivery process.

---

## **Pipeline Architecture**  
![image](https://github.com/user-attachments/assets/1e63927d-d6f6-4c78-becf-9d28cc3aa2fc)



### **1. Build Stage**  
- **Tools**: Docker + Maven  
- **Key Features**:  
  ```yaml
  docker build \
    --build-arg MAVEN_OPTS="-Dmaven.repo.local=.m2/repository" \
    -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
  ```
  - Uses **Docker BuildKit** for faster builds  
  - Caches Maven dependencies in `.m2/repository`  

### **2. Test Stage**  
- **Tools**: JUnit + Maven  
- **Optimizations**:  
  ```yaml
  cache:
    key: "$CI_COMMIT_REF_SLUG"
    paths:
      - .m2/repository  # Reuses cached dependencies
      - target/         # Caches compiled classes
  ```

### **3. Security Scanning**  
#### **SAST (Trivy Filesystem Scan)**  
```bash
trivy fs --security-checks vuln,config .
```
- Scans for:  
  - Hardcoded secrets  
  - Misconfigurations in `pom.xml`  
  - Vulnerable dependencies  

#### **Container Scan (Trivy)**  
```bash
trivy image --exit-code 0 $DOCKER_TAG
```
- Checks Docker image for:  
  - OS package vulnerabilities (CVE)  
  - Root user usage (`HIGH` severity)  
  - Missing healthchecks (`LOW` severity)  

### **4. Deployment**  
- **SSH-based Docker Deployment**:  
  ```bash
  ssh user@server "docker pull $IMAGE && docker run -p 8080:8080 $IMAGE"
  ```


---

## **Security Highlights**  
| Tool          | Purpose                         |
|---------------|---------------------------------|
| **Trivy**     | Container + Dependency Scanning |
| **GitLab SAST** | Static Code Analysis          |
| **OWASP DC**  | Dependency Checks               |

---

## **Local Development Setup**  
### **Prerequisites**  
- Java 17  
- Docker 24+  
- Maven 3.8+  

### **Run Locally**  
```bash
mvn spring-boot:run  # Dev mode
docker build -t spring-app . && docker run -p 8080:8080 spring-app  
```

---

## ** Learning Resources**  
1. [GitLab CI Variables](https://docs.gitlab.com/ee/ci/variables/)  
2. [Trivy Scanning Guide](https://aquasecurity.github.io/trivy/)  
3. [Spring Boot Dockerization](https://spring.io/guides/gs/spring-boot-docker/)  

---

## **Performance Optimizations**  
| Technique               | Time Saved |  
|-------------------------|------------|  
| Maven Dependency Caching | ~3 min     |  
| Trivy Cache Reuse        | ~2 min     |  
| Parallel Test Execution  | ~1.5 min   |  

---

## **Good Questions**  
**Q: Why use Trivy instead of GitLab's built-in scanners?**  
A: Trivy provides **faster scans** and **broader vulnerability coverage** for Java apps.  

**Q: How to handle secret management?**  
A: Store credentials in **GitLab CI Variables** (Settings > CI/CD > Variables).  

---

## **Pipeline Diagram**
Succeeded Pipeline & RepoLink:
https://gitlab.com/fawry-intern1/anas_ayman_elgalad/spring_boot_project  
![image](https://github.com/user-attachments/assets/1841ca32-c6e2-42d6-a436-eb5c64e28254)

---

**Tip**: Run `mvn dependency:tree` to audit dependencies before commits!
