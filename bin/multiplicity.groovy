import org.jlab.io.hipo.HipoDataSource
import groovy.json.JsonOutput

if(args.length<1) {
  System.err.println """
  USAGE: run-groovy ${this.class.getSimpleName()}.groovy [HIPO file from reconstruction]
  """
  System.exit(101)
}

def inFile = args[0]
def outFile = inFile
  .replaceAll(/\.hipo$/,".txt")
  .replaceAll(/^rec/,"multiplicity")
def outFileH = new File(outFile)
def outFileW = outFileH.newWriter(false)

def reader = new HipoDataSource()
reader.open(inFile)

mult = [:]
while(reader.hasEvent()) {
  event = reader.getNextEvent()
  particleBank = event.getBank("REC::Particle")
  (0..<particleBank.rows()).each{
    pid = event.getBank("REC::Particle").getInt('pid',it)
    if(mult[pid]==null)
      mult[pid] = 1
    else
      mult[pid]++
  }
}
mult = mult.sort{ -it.value }

print "multiplicity: "
println JsonOutput.prettyPrint(JsonOutput.toJson(mult))

mult.each{ outFileW << sprintf("%14s  ", sprintf("%d (%d)", it.key, it.value)) }
outFileW << '\n'
outFileW.close()

println "wrote $outFile"
