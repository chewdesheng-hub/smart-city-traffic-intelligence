# smart-city-traffic-intelligence
Chew De Sheng NUS capstone
# Smart City Traffic Intelligence: Reproducible Data Analytics Pipeline

This repository contains **Part 2** of the Smart City Traffic Intelligence Capstone project. It implements a multi-stage Python data pipeline that cleans, validates, transforms, and analyzes approximately 48,000 hourly westbound traffic volume records from the I-94 interstate highway near Minneapolis–St Paul.

## 📁 Project Directory Structure
Following professional software engineering practices, the project is structured as follows:

```text
smart-city-traffic-capstone/
│
├── part2_python/
│   ├── pipeline.py               # Data loading, schema validation, and cleaning pipeline
│   ├── feature_engineering.py    # NumPy and Pandas transformations & feature generation
│   ├── visualizations.py         # Matplotlib scripts to output descriptive figures
│   ├── cli_app.py                # Command-line analytics interface
│   ├── pipeline.log              # Sample output execution logs
│   ├── README.md                 # Project documentation and execution guide
│   │
│   ├── figures/                  # Directory containing generated data visualizations
│   │   ├── hourly_traffic_weekday_vs_weekend.png
│   │   ├── traffic_by_weather_condition.png
│   │   └── temperature_vs_traffic.png
│   │
│   └── data/
│       ├── Metro_Interstate_Traffic_Volume.csv  # Raw data input
│       ├── cleaned_traffic_data.csv             # Output of Task 1
│       └── engineered_traffic_data.csv          # Output of Task 2
```

---

## 🚀 How to Run the Project

### Prerequisites
Ensure you have Python 3.8+ installed along with the required libraries:
```bash
pip install pandas numpy matplotlib seaborn
```

### Execution Steps
Run the pipeline components in their logical execution order:

1. **Execute the Data Pipeline (Task 1):**
   This script loads the raw CSV, validates schemas, eliminates duplicates, filters physical anomalies (such as 0 Kelvin temperatures), and applies monthly median imputations.
   ```bash
   python pipeline.py
   ```

2. **Run Feature Engineering (Task 2):**
   Processes the cleaned data to create model-ready features (cyclical encodings, one-hot vectors, min-max scalers).
   ```bash
   python feature_engineering.py
   ```

3. **Generate Visualizations (Task 3):**
   Generates and exports data insight figures directly to the `figures/` folder.
   ```bash
   python visualizations.py
   ```

4. **Launch the Mini Analytics App (Task 4):**
   Interact with the final processed dataset via the CLI terminal window:
   ```bash
   python cli_app.py
   ```

---

## 🪵 Logging Architecture and Configurations

This codebase completely avoids internal `print()` tracking statements, relying exclusively on Python's native `logging` module to output production-grade runtime tracking.

### Configuration Details
* **Logger Name:** Instantiated via `logging.getLogger(__name__)` to prevent base root logger collision.
* **Output Destinations:** Handlers stream logs simultaneously to **standard output (Console)** and write to a physical tracking file named `pipeline.log`.
* **Standard Log Layout Format:**
  `⚡ Timestamp - Log Level - Module/Name - Log Message`
  *(e.g., `2026-09-27 02:13:45 - INFO - __main__ - Schema validation passed.`)*

### Logging Level Matrices

| Level | Severity | Application Scenario in Pipeline | Sample Log Entry |
| :--- | :--- | :--- | :--- |
| **DEBUG** | Fine-Grained | Internal threshold and quartile split value computations. | `Intermediate Calculation - Traffic Quartile Thresholds: Q1 (25%) = 1192.5` |
| **INFO** | Milestones | Successful asset initialization, complete data save loops, or file dumps. | `Successfully loaded raw dataset with 48204 rows and 9 columns.` |
| **WARNING** | Recoverable | Anomalies handled via programmatic strategies (imputation, dropping rows). | `Dropped 17 duplicate rows from dataset. Remaining row count: 48187.` |
| **ERROR** | Unrecoverable | Critical File I/O exceptions or broken schemas causing early graceful exit. | `Failed to parse 'date_time' column: [Traceback Data]` |
