Move the raw data directories `Authority Code` and `Standard` from the unzipped contents into the `data` directory. The containing folder names vary per release.

```
MAY18_GNAF_PipeSeparatedValue_20180521161504/
    - G-NAF/
        - G-NAF MAY 2018/
            - Authority Code
            - Standard
```

e.g.

```sh
mv "MAY18_GNAF_PipeSeparatedValue_20180521161504/G-NAF/G-NAF MAY 2018/Authority Code" data
mv "MAY18_GNAF_PipeSeparatedValue_20180521161504/G-NAF/G-NAF MAY 2018/Standard" data
```