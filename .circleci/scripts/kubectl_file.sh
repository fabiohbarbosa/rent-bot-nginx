#!/bin/bash
set -e # ensure that this script will return a non-0 status code if any of rhe commands fail
set -o pipefail # ensure that this script will return a non-0 status code if any of rhe commands fail

cat << EOF > service.yaml

---
apiVersion: v1
kind: Service
metadata:
  name: $GROUP-$SERVICENAME
spec:
  selector:
    app: $GROUP-$SERVICENAME
  type: NodePort
  ports:
    - protocol: TCP
      port: $PORT
      targetPort: $PORT
      nodePort: $NODE_PORT

---
apiVersion: extensions/v1beta1
kind: Deployment

metadata:
  name: $GROUP-$SERVICENAME
  labels:
    imageTag: '$VERSION'
spec:
  revisionHistoryLimit: 15
  replicas: $REPLICAS
  strategy:
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: $GROUP-$SERVICENAME
    spec:
      containers:
      - name: $GROUP-$SERVICENAME
        image: gcr.io/$CLOUD/$GROUP/$SERVICENAME:$VERSION
        env:
          - name: ENVIRONMENT
            value: $ENVIRONMENT
        ports:
          - containerPort: $PORT
        readinessProbe:
          httpGet:
            path: /healthcheck
            port: $PORT
          initialDelaySeconds: 15
          timeoutSeconds: 1
          periodSeconds: 5
          failureThreshold: 1
        livenessProbe:
          httpGet:
            path: /healthcheck
            port: $PORT
          initialDelaySeconds: 15
          periodSeconds: 15
          timeoutSeconds: 5
          failureThreshold: 4
        resources:
          limits:
            memory: 200Mi
          requests:
            memory: 200Mi

EOF
kubectl apply -f service.yaml