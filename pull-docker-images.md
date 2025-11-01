
Get images from running pods:

```
kubectl -n monitoring get pods -o yaml | grep "image:"
```
```
kubectl -n longhorn-system get pods -o yaml | grep "image:"
```

Or:

bash pull-docker-images.bash (change namespace variable)