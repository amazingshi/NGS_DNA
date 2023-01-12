set -o pipefail
#Parameter mapping
#string logsDir
#string tmpDirectory
#string intermediateDir
#string project
#string groupname
#string tmpName
#string tempDir
#list sampleBatchGenotypedVariantCalls
#string projectBatchGenotypedVariantCalls
#string indexFileDictionary

module load "${gatkVersion}"

array_contains () {
	local array="$1[@]"
	local seeking=$2
	local in=1
	for element in "${!array-}"; do
		if [[ "${element}" == "${seeking}" ]]; then
			in=0
			break
		fi
	done
	return "${in}"
}

makeTmpDir "${projectBatchGenotypedVariantCalls}"
tmpProjectBatchGenotypedVariantCalls="${MC_tmpFile}"

for extId in "${sampleBatchGenotypedVariantCalls[@]}"
do
	array_contains INPUTS "-I ${extId}" || INPUTS+=("-I ${extId}") 	# If bamFile does not exist in array add it
done
# shellcheck disable=SC2068 #${INPUTS} => gatk needs seperate strings, not one captured in quotes
gatk --java-options "-Xmx7g" MergeVcfs \
${INPUTS[@]} \
-D "${indexFileDictionary}" \
-O "${tmpProjectBatchGenotypedVariantCalls}"

mv -v "${tmpProjectBatchGenotypedVariantCalls}" "${projectBatchGenotypedVariantCalls}"

