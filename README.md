# docker-python-pyspark-pytest
Docker python/3.6-alpine image with pyspark and pytest.

To run your own project's unit tests within this container:

```
docker run -v $(pwd):/some-container-dir -it dwpdigital/python3-pyspark-pytest /bin/sh
cd /some-container-dir
pytest tests
```

Note that if your container is running in an environment with no/limited
Internet connectivity then you should configure PySpark to use the included local
Ivy & Maven repositories by setting the `PYSPARK_SUBMIT_ARGS` environment variable
before creating your Spark session, e.g. in `tests/conftest.py`:

```
def spark():
    os.environ["PYSPARK_SUBMIT_ARGS"] = '--packages "org.apache.hadoop:hadoop-aws:2.7.3" --conf spark.jars.ivySettings=/root/ivysettings.xml pyspark-shell'
    os.environ["PYSPARK_PYTHON"] = ('python3')
    os.environ["PYSPARK_DRIVER_PYTHON"] = ('python3')
    spark = (
        SparkSession.builder.master("local")
            .appName("test")
            .enableHiveSupport()
            .getOrCreate()
    )
```
