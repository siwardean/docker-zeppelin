# zeppelin

A `debian:stretch` based Spark and [Zeppelin](https://zeppelin.apache.org) Docker container highly inspired from the dylanmei/zeppelin image.

This image is large and opinionated. It contains:

- [Spark 2.4.1](https://spark.apache.org/docs/latest) and [Hadoop 3.0.0](https://hadoop.apache.org/docs/r3.0.0)
- [PySpark](https://spark.apache.org/docs/latest/api/python) support with [Python 3](https://docs.python.org/3), [NumPy](https://www.numpy.org), [PandaSQL](https://github.com/yhat/pandasql), and [SciPy](https://www.scipy.org/scipylib/index.html), but no matplotlib.
- A partial list of interpreters out-of-the-box. If your favorite interpreter isn't included, consider [adding it with the api](http://zeppelin.apache.org/docs/0.8.2/).
  - spark
  - shell
  - angular
  - markdown
  - jdbc
  - python
  - hbase
  - elasticsearch
 
## simple usage

To start Zeppelin pull the `latest` image and run the container:

```
docker pull smadrane/zeppelin
docker run --rm -p 8080:8080 smadrane/zeppelin
```

Zeppelin will be running at `http://${YOUR_DOCKER_HOST}:8080`.

## complex usage

You can use [docker-compose](https://docs.docker.com/compose) to easily run Zeppelin in more complex configurations. See this project's `./examples` directory for examples of using Zeppelin with `docker-compose` to :

- read and write from local data files (Tested)
- read and write documents in ElasticSearch (Not tested)

## license

MIT
