This README is designed to provide a professional, "day-zero" experience for developers and data engineers using the companion repository for the **EDB Postgres Analytics Accelerator (AA)** tutorial.

---

# EDB Postgres AI: Spark RAPIDS Accelerator Tutorial

This repository contains the companion artifacts for the EDB tutorial on GPU-accelerated analytics. It demonstrates how to offload heavy PostgreSQL analytical workloads to an **OSS Apache Spark** cluster powered by **NVIDIA RAPIDS** and **NVIDIA L40S GPUs**.

## 📁 Repository Structure

* **`cpu-only/`**: Contains Docker Compose files and configurations for local development. Use this to validate your PGAA-to-Spark connection using standard CPU resources and the TPC-DS SF10 dataset.
* **`gpu-2xl40s/`**: Contains the production-grade artifacts for the **NVIDIA Brev** environment. This includes the RAPIDS plugin configuration, optimized shuffle managers, and tuning for dual **NVIDIA L40S** GPUs.

---

## 🛠️ Prerequisites

Before starting, ensure you have the following:

1. **EDB Token**: Required to pull EDB Postgres AI images. Set this as an environment variable: `export EDB_TOKEN=your_token_here`.
2. **Docker & Docker Compose**: Docker Desktop (Local) or NVIDIA Container Toolkit (Cloud/Brev).
3. **TPC-DS Data**:
* SF10 for local testing.
* SF100 for GPU benchmarking (place in `/ephemeral/tpcds_sf_100` for the GPU setup).



---

## 🚀 Quick Start

### Phase 1: Local CPU Validation

Ideal for checking the "plumbing" of the system on your laptop.

```bash
cd cpu-only
docker compose up -d

```

* **Postgres**: `localhost:5432`
* **Spark Master UI**: `localhost:8080`

### Phase 2: GPU Acceleration (NVIDIA Brev)

Designed for the **NVIDIA L40S** instance to witness 100GB+ datasets processed in seconds.

```bash
cd gpu-2xl40s
docker compose up -d

```

* **Postgres**: `localhost:5432`
* **Spark Master UI**: `localhost:8080`
* **Spark SQL UI (GPU Metrics)**: `localhost:4040`

---

## 🔍 Key Configuration Highlights

### The RAPIDS Plugin

Our `gpu-2xl40s` compose file injects the `com.nvidia:rapids-4-spark` package into the Spark lifecycle. This allows Spark to:

* Replace CPU operators with **GPU Kernels**.
* Use the **RapidsShuffleManager** for fast data movement.
* Leverage **Pinned Memory** pools for high-speed CPU-to-GPU transfers.

### Performance Tuning

The GPU configuration is tuned specifically for the 48GB VRAM of the L40S:

* `spark.executor.memory`: 64g
* `spark.rapids.memory.pinnedPool.size`: 8g
* `spark.rapids.sql.concurrentGpuTasks`: 3

---

## 📊 Running the Benchmark

Once the stack is up, connect to Postgres and run:

```sql
-- Query 19: Join-heavy aggregation
SELECT i_brand_id, i_brand, sum(ss_ext_sales_price) as total_sales
FROM store_sales
JOIN item ON ss_item_sk = i_item_sk
WHERE i_manufact_id = 128
GROUP BY i_brand_id, i_brand
ORDER BY total_sales DESC;

```

Check the **Spark UI (4040)** to see the `GpuHashJoin` and `GpuHashAggregate` nodes in the physical plan.

---

## ⚖️ License

This repository is provided for educational purposes as part of the EDB Postgres AI tutorial series. EDB Postgres AI components are subject to their respective EDB licenses.
