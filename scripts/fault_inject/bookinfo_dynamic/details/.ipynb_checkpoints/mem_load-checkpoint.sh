dir="$(dirname "$0")"
total_count=$1
is_scale=$2
let count=1

for ((i=1;i<=$total_count;i++))
do
	echo $3_mem_load_$count
    start_timestamp=$(date +%s) 
    start_timestamp=$((start_timestamp - 6 * 60))  
	kubectl apply -f $dir/mem_load.yaml -n chaos-mesh
	echo "$(date +"%Y-%m-%d %T") start create."
    sleep 60
    if [ $is_scale -gt 0 ]; then
        echo "$(date +"%Y-%m-%d %T") start scale up 1."
        kubectl scale deployment details-v1 --replicas=$(( $(kubectl get deployment details-v1 -n bookinfo -o=jsonpath='{.spec.replicas}') + 1)) -n bookinfo
    fi
	sleep 120
	echo "$(date +"%Y-%m-%d %T") start delete."
	kubectl delete -f $dir/mem_load.yaml -n chaos-mesh
	echo "$(date +"%Y-%m-%d %T") finish delete."
    sleep 60
    if [ $is_scale -gt 0 ]; then
        echo "$(date +"%Y-%m-%d %T") start scale down 1."
        before_timestamp=$(date +%s) 
        python $dir/../log-collect/Log.py $3_mem_load_$count before $start_timestamp $before_timestamp
        kubectl scale deployment details-v1 --replicas=$(( $(kubectl get deployment details-v1 -n bookinfo -o=jsonpath='{.spec.replicas}') - 1)) -n bookinfo
    fi
    after_timestamp=$(date +%s) 
	echo -e "\n"
	sleep 660
	((count++))
    if [$is_scale -gt 0];then
        end_timestamp=$((after_timestamp + 6 * 60))  
        python $dir/../log-collect/Log.py $3_mem_load_$count after 'after' $after_timestamp $end_timestamp
    fi
done