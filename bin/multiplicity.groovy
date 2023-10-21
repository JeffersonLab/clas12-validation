// print the multiplicity (number of counts) for each particle PID PDG found in a HIPO file, and store the results in a text file
// - run with `run-groovy`

import org.jlab.io.hipo.HipoDataSource
import groovy.json.JsonOutput

def outFile = "multiplicity.txt"
if(args.length<1) {
  System.err.println """
  USAGE: run-groovy ${this.class.getSimpleName()}.groovy [HIPO file from reconstruction] [output file name (default=$outFile)]
  """
  System.exit(101)
}

def inFile = args[0]
if(args.length>1) outFile = args[1]
def outFileH = new File(outFile)
def outFileW = outFileH.newWriter(false)

def reader = new HipoDataSource()
reader.open(inFile)

def particleBankName = inFile.contains(/FT/) ? "RECFT::Particle" : "REC::Particle"

mult = [:]
while(reader.hasEvent()) {
  event = reader.getNextEvent()
  particleBank = event.getBank(particleBankName)
  (0..<particleBank.rows()).each{
    pid = event.getBank(particleBankName).getInt('pid',it)
    if(mult[pid]==null)
      mult[pid] = 1
    else
      mult[pid]++
  }
}
mult = mult.sort{ -it.value }

outFileW << "multiplicity from `$particleBankName`\n" << JsonOutput.prettyPrint(JsonOutput.toJson(mult)) << '\n'
mult.each{ outFileW << sprintf("%14s  ", sprintf("%d (%d)", it.key, it.value)) }
outFileW << '\n'
outFileW.close()

println "wrote $outFile"
