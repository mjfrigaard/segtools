
# segtools 1.1.1

* New tests for `import_flat_file()`

    ```bash
    ==> devtools::test()
    
    ℹ Testing segtools
    ✔ | F W S  OK | Context
    ✔ |         3 | import_flat_file [0.2s]                                                                     
    ✔ |         1 | seg_binom_table [0.5s]                                                                      
    ✔ |         1 | seg_iso_range_tbl [0.6s]                                                                    
    ✔ |         1 | seg_iso_vars [0.4s]                                                                       
    ✔ |         1 | seg_pair_type_tbl [0.1s]                                                                    
    ✔ |         1 | seg_risk_cat_tbl [0.4s]                                                                     
    ✔ |         1 | seg_risk_cat_vars [0.2s]                                                                    
    ✔ |         1 | seg_risk_cols [0.7s]                                                                        
    ✔ |         1 | seg_risk_grade_tbl [0.4s]                                                                      
    
    ══ Results ══════════════════════════════════════════════════════════════════
    Duration: 3.7 s
    
    [ FAIL 0 | WARN 0 | SKIP 0 | PASS 11 ]
    ```
    
## Graphs 
    
* Updated `seg_modba_graph.R`   

  - Now includes a fill *and* color var input (using shape `21`)  
  
  - Text size increased for better web rendering 

* Updated `seg_graph.R`  

  - New points and lines with higher contrast colors  
  
  - Axis titles added  
  
  - Text size increased for better web rendering 


# segtools 1.1.0

* Updated functions to standardize names: 

    - functions and outputs with a `_cols` suffix are intermediate/utility functions
    - functions and outputs with a `_vars` suffix are create outputs for the primary `_tbl` and `_graph` functions   
    - input arguments align with function names (i.e. `seg_risk_vars()` creates the output for functions with the `risk_vars` argument)
    
* Re-written [`risk-tables`](https://mjfrigaard.github.io/segtools/articles/risk-tables.html) vignette to be more organized.

* Added [SEG Graph vignette](https://mjfrigaard.github.io/segtools/articles/seg-graph.html) 

# segtools 1.0.0

* Updated package functions to match shiny application outputs

  - See vignette [`risk-tables`](https://mjfrigaard.github.io/segtools/articles/risk-tables.html)

<br>

* Unit tests for each function 

    ```bash
    ==> devtools::test()
    
    ℹ Testing segtools
    ✔ | F W S  OK | Context
    ✔ |         1 | seg_binom_tbl [0.5s]                     
    ✔ |         1 | seg_iso_range_tbl [0.4s]                    
    ✔ |         1 | seg_iso_cols [0.3s]                         
    ✔ |         1 | seg_pair_type_tbl                           
    ✔ |         1 | seg_risk_cat_tbl [0.3s]                    
    ✔ |         1 | seg_risk_cat_cols [0.3s]                   
    ✔ |         1 | seg_risk_vars [0.6s]                       
    ✔ |         1 | seg_risk_grade_tbl [0.3s]                  
    
    ══ Results ═══════════════════════════════════
    Duration: 2.8 s
    
    [ FAIL 0 | WARN 0 | SKIP 0 | PASS 8 ]
    ```

* Data from previous build accessible with `get_seg_data()` function 

    ```r
    get_seg_data('VanderbiltComplete')
    # A tibble: 9,891 × 2                                                            
         BGM   REF
       <dbl> <dbl>
     1   121   127
     2   212   223
     3   161   166
     4   191   205
     5   189   210
     6   104   100
     7   293   296
     8   130   142
     9   261   231
    10   147   148
    # … with 9,881 more rows
    # ℹ Use `print(n = ...)` to see more rows
    ```
    
    - Use `get_seg_data('names')` for list of datasets 
    
    ```r
    get_seg_data('names')
     [1] "VanderbiltComplete.csv"   "AppRiskPairData.csv"      "RiskPairData.csv"        
     [4] "AppLookUpRiskCat.csv"     "LookUpRiskCat.csv"        "AppTestData.csv"         
     [7] "AppTestDataSmall.csv"     "AppTestDataMed.csv"       "AppTestDataBig.csv"      
    [10] "FullSampleData.csv"       "ModBAData.csv"            "No_Interference_Dogs.csv"
    [13] "SEGRiskTable.csv"         "SampMeasData.csv"         "SampleData.csv"          
    [16] "lkpRiskGrade.csv"         "lkpSEGRiskCat4.csv"  
    ```

# segtools 0.0.1

* This package has been configured to use the [`pak` + `renv`](https://rstudio.github.io/renv/reference/config.html#configuration) by including `renv.config.pak.enabled = TRUE` in the `.Rprofile` 

# segtools 0.0.0.9000
## `pkgdown`

* Building the `pkgdown` version of the package has been a nightmare. The various `pkgdown` builds/failures are listed below: 

* [Build #1](https://github.com/mjfrigaard/segtools/commit/e8b14747709d01356d76712a6cc027dd71aa0d00)

* [pkgdown build #3 #2](https://github.com/mjfrigaard/segtools/commit/7679b1460a950230363ff0fcc798830e65a2106d) and [pkgdown build #5 #3](https://github.com/mjfrigaard/segtools/commit/59b4745f6b66c51e539018de5013fc82b2c8ff9a) had the same error on `readxl`

```bash
✖ Failed to build segtools 0.0.0.9000
  Error: 
  ! error in pak subprocess
  Caused by error in `stop_task_build(state, worker)`:
  ! Failed to build source package 'segtools'
  Full installation output:
  * installing *source* package ‘segtools’ ...
  staged installation is only possible with locking
  ** using non-staged installation
  ** R
  ** data
  *** moving datasets to lazyload DB
  ** inst
  ** byte-compile and prepare package for lazy loading
Error in loadNamespace(j <- i[[1L]], c(lib.loc, .libPaths()), versionCheck = vI[[j]]) : 
    there is no package called ‘readxl’
  Calls: <Anonymous> ... loadNamespace -> withRestarts -> withOneRestart -> doWithOneRestart
  Execution halted
  ERROR: lazy loading failed for package ‘segtools’
  * removing ‘/tmp/RtmpHJLGW5/pkg-lib1352430479ed/segtools’
  ---
  Backtrace:
  1. pak::lockfile_install(".github/pkg.lock")
  2. pak:::remote(function(...) { …
  3. err$throw(res$error)
  ---
  Subprocess backtrace:
   1. base::withCallingHandlers(cli_message = function(msg) { …
   2. get("lockfile_install_internal", asNamespace("pak"))(...)
   3. plan$install()
   4. pkgdepends::install_package_plan(plan, lib = private$library, num_workers = nw, …
   5. base::withCallingHandlers({ …
   6. pkgdepends:::handle_events(state, events)
   7. pkgdepends:::handle_event(state, i)
   8. pkgdepends:::stop_task(state, worker)
   9. pkgdepends:::stop_task_build(state, worker)
  10. base::throw(new_pkg_build_error("Failed to build source package {pkg}", …
  11. | base::signalCondition(cond)
  12. global (function (e) …
  Execution halted
  Error: Process completed with exit code 1.
```

After removing the `readxl` from the package, the build worked (almost). 

5. [Buildpkgdown build #7 #5](https://github.com/mjfrigaard/segtools/actions/runs/4440538030)

`The deploy step encountered an error: The process '/usr/bin/git' failed with exit code 128 ❌` 

This required changing the settings under **Settings** > **Actions** > **General** > change *Workflow permissions* to *Read and write permissions*  

6. [Build #7](https://github.com/mjfrigaard/segtools/commit/e11fb2da9b558d94ad05cff0a5468e93c2bfd2b9)

* Added a `NEWS.md` file to track changes to the package.
