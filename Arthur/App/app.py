import base64
import datetime
import json
from flask import Flask, jsonify,render_template, request,flash,session, redirect, url_for
from web3 import Web3
import MyContract as TheCon
import PactitionerAccounts as ThePrac
import ipfshttpclient
import jwt



app = Flask(__name__)
app.secret_key="CODEyakaomaVARUMEWOYEplusHIT400ndeyekumama"
client = ipfshttpclient.connect()




   





@app.route('/')
def hello():
    users=TheCon.GetAllUsers()
    pracs=ThePrac.GetAllPractitioners()


    return render_template('index.html', users=users,pracs=pracs)


@app.route('/munhu/<person>/')
def hello_user(person):
    session["Person"]=person
    session["User"]=person  
   
    pp=TheCon.GetPersonalDetails(person,person)


    return render_template('index1.html', person=person, pp=pp)


@app.route('/prac/<practitioner>/')
def hello_practitioner(practitioner):
    session["User"]=practitioner
    session['Practitioner']=practitioner
    
    pp=ThePrac.GetMedicalPractitioner(practitioner)


    return render_template('index2.html', practitioner=practitioner,pp=pp)


@app.route('/register/', methods=['POST', 'GET'])
def addSelf():
    if request.method=="POST":
        name=request.form['fname']
        dob=str(request.form['dob'])
        mail=request.form['email']
        phn=request.form['phone']
        phn1=request.form['phone1']
        addr=request.form['addr']
        natid=request.form['nid']
        passno=request.form['pnum']
        passexp=str(request.form['pexp'])
        empstat=request.form['empstatus']
        edu=request.form['edu']

        riz=TheCon.AddAPersonalDetails(name, dob, mail, phn, phn1, addr, natid, passno, passexp, empstat, edu)

        return render_template('_addSelf.html', riz=riz)
    
    
    return render_template('_addSelf.html', riz={'Status':"Add"})


@app.route('/upload/<person>/', methods=['POST', 'GET'])
def Uploads(person):
    if request.method=="POST":
        doctype=request.form['doctype']
        docc=request.files['uploads']
        print(docc.filename)
        flext=docc.filename.split('.')[-1]
        
       
        contents = docc.read()
        res = client.add_bytes(contents)
        print(res)

        

        rez=TheCon.AddDocument(doctype,res, person, flext)
        flash("Document added.")
        
        return render_template('_addUploads.html', riz=rez)
    
    
    return render_template('_addUploads.html', riz={'Status':"Add"})

#documents here
#add upload to the documents page
@app.route('/view/<person>/', methods=['POST', 'GET'])
def personView(person):
    pp=TheCon.GetPersonalDetails(person,person)
    dc=TheCon.GetRegisteredDocuments(person)
    rez={}
    for i in dc:
        the_doc=TheCon.GetDocument( person,i,  person)
        rez[i]={'Document': base64.b64encode(client.cat(the_doc[0])).decode('utf-8'), 'Typed':the_doc[1]}
    

    
    return render_template('_one.html', pp=pp, dc=dc, rez=rez, person=person)

#pdf viewer
@app.route('/pdf_view/<person>/<documen>', methods=['POST', 'GET'])
def pdfView(person,documen):
    pp=TheCon.GetPersonalDetails(person,person)

    rez={}
    
    the_doc=TheCon.GetDocument( person,documen,  person)
    rez[documen]={'Document': base64.b64encode(client.cat(the_doc[0])).decode('utf-8'), 'Typed':the_doc[1]}
    

    
    return render_template('_pdfview.html',  pp=pp, rez=rez, person=person)


@app.route('/medicals/<info>/<person>/')
def addMedicals(info,person):
    
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"}, person=person, info=info)



#add allergy
@app.route('/addllergies/<person>/', methods=['POST', 'GET'])
def addAllergy(person):
    if request.method=="POST":
        allergy=request.form['allergy']

        rez=TheCon.AddAAllergies(allergy,person,session['User'])

        
        return redirect(url_for('viewMedicalRecords', person=person))
    
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"}, person=person)

#medical condition
@app.route('/medicalcondition/<person>/', methods=['POST', 'GET'])
def addCondition(person):
    if request.method=="POST":
        conditionz=request.form['conditionz']

        rez=TheCon.AddAMedicalConditions(conditionz,person,session['User'])

        
        return redirect(url_for('viewMedicalRecords', person=person))
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"})


@app.route('/bloodtype/<person>/', methods=['POST', 'GET'])
def addBloodtype(person):
    if request.method=="POST":
        bloodtype=request.form['bloodtype']

        rez=TheCon.AddABloodType(bloodtype,person,session['User'])

        
        return redirect(url_for('viewMedicalRecords', person=person))
        
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"}, person=person)

#prescripttion
@app.route('/addprescription/<person>/', methods=['POST', 'GET'])
def addPrescription(person):
    if request.method=="POST":
        _Prescription=request.form['_Prescription']
        _PrescriptionDate=str(request.form['_PrescriptionDate'])
        _Status=False


        rez=TheCon.AddAPrescription(_Prescription,_Status , _PrescriptionDate,person, session['User'])

        return redirect(url_for('viewMedicalRecords', person=person))
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"})

#add update prescription here
@app.route('/register/<pres>/<person>/<status>', methods=['POST', 'GET'])
def addUpdatePrescription(pres, person,status):
    if request.method=="POST":
        riz=TheCon.UpadatePrescriptionStatus(pres,  status, person, session['User'])
        return redirect(url_for('viewMedicalRecords', person=person))
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"})

        







#Diagnosis
@app.route('/addDiagnosis/<person>/', methods=['POST', 'GET'])
def addDiagnosis(person):
    if request.method=="POST":
        _Diagnosis=request.form['_Diagnosis']
        _DiagnosisDate=str(request.form['_DiagnosisDate'])
     


        riz=TheCon.AddDiagnosis(_Diagnosis, _DiagnosisDate,person, session['User'])

        return redirect(url_for('viewMedicalRecords', person=person))
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"})


#medical test
@app.route('/register/<person>/', methods=['POST', 'GET'])
def addTest(person):
    if request.method=="POST":
        _Test=request.form['_Test']
        _TestDate=str(request.form['_TestDate'])
     


        riz=TheCon.AddMedicalTest(_Test, _TestDate,person, session['User'])

        return redirect(url_for('viewMedicalRecords', person=person))
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"})


#update medical test result
@app.route('/register/<test>/<person>/', methods=['POST', 'GET'])
def addTestResult(test, person):
    if request.method=="POST":
        _TestResult=request.form['_TestResult']

     


        riz=TheCon.UpdateMedicalTestResult(test, _TestResult, person, session['User'])

        return redirect(url_for('viewMedicalRecords', person=person))
    
    
    return render_template('_addAllergy.html', riz={'Status':"Add"})






#medical records
@app.route('/medicals/<person>/', methods=['POST', 'GET'])
def viewMedicalRecords(person):
    pp=TheCon.GetPersonalDetails(person,person)
    allz=TheCon.GetAllergies(person,person)
    condz=TheCon.GetMedicalConditions(person,person)
    bt=TheCon.GetBloodType(person,person)
    prescz=TheCon.GetPrescriptions(person,person)
    disz=TheCon.GetDiagnoses(person,person)
    tstz=TheCon.GetMedicalTests(person,person)
    
    
    return render_template('_medicalRecords.html', riz={'Status':"Add"}, pp=pp, allz=allz,
                           condz=condz,bt=bt,prescz=prescz,disz=disz,tstz=tstz,person=person)






@app.route('/share/<person>/', methods=['POST', 'GET'])
def shareItems(person):
    pp=TheCon.GetPersonalDetails(person,person)
    dc=TheCon.GetRegisteredDocuments(person)
    medz=['Allergies', 'Medical Conditions','Blood Type', 'Prescriptions & Medication', 'Diagnoses', 'Medical Tests']

    if request.method=='POST':
        user=request.form['User']
        msr=request.form.get('durationmrs')
        duration=float(request.form['duration'])
        meds=request.form.getlist('medicals')
        docs=request.form.getlist('documents')
        personal_info=request.form.get('PersonalDetails')
        if personal_info=='PersonalDetails':
            a=True
        else:
            a=False
      
        data={'PersonalDetails':a, 'Documents':docs, 'Medicals':meds, 'User':user,'DataFor':person}
        dt=linked(data,msr,duration)

        #return jsonify('<div id="rnd">'+dt+' </div>')
        return render_template('_link.html', linkd=dt)
    
    
    
    return render_template('_shareItems.html', docs=dc,pp=pp,medz=medz,person=person)













#email activtion link generation
def linked(mailed, msr, duration): 
    if msr=="Minutes":
        tm=datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(minutes=duration)
    elif msr=="Hours":
        tm=datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(hours=duration)
    elif msr=="Weeks":
        tm=datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(weeks=duration)
    elif msr=="Months":
        tm=datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(weeks=duration*4)
    else:
        tm=datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(weeks=duration*4*52)

    token1=jwt.encode({'data':mailed,"exp": tm}, app.config['SECRET_KEY'], algorithm="HS256")
    url_out=url_for("activate", link2=token1, _external=True)
    return url_out
#cel activtion link generation



@app.route('/practitioner/view/<link2>')
def activate(link2):
    try:
        data=jwt.decode(link2, app.config['SECRET_KEY'] ,algorithms="HS256")
        if (data['data']['User']=="" or data['data']['User']==session['Practitioner']) or data['data']['User']==session['User']:
            pp=TheCon.GetPersonalDetails(data['data']['DataFor'],data['data']['DataFor'])
            dc=data['data']['Documents']
            rez={}
            for i in dc:
                print(i)
                the_doc=TheCon.GetDocument( data['data']['DataFor'], i, data['data']['DataFor'])
                rez[i]={'Document': base64.b64encode(client.cat(the_doc[0])).decode('utf-8'), 'Typed':the_doc[1]}
                #rez[i]=base64.b64encode(client.cat(TheCon.GetDocument(data['data']['DataFor'], i, data['data']['DataFor']))).decode('utf-8')
            #medz=['Allergies', 'Medical Conditions','Blood Type', 'Prescriptions & Medication', 'Diagnoses', 'Medical Tests']
            medical_data={}
            if 'Allergies' in data['data']['Medicals']:
                medical_data['Allergies']=TheCon.GetAllergies(data['data']['DataFor'],data['data']['DataFor'])
            if 'Medical Conditions' in data['data']['Medicals']:
                medical_data['Medical Conditions']=TheCon.GetMedicalConditions(data['data']['DataFor'],data['data']['DataFor'])
            if 'Blood Type' in data['data']['Medicals']:
                medical_data['Blood Type']=TheCon.GetBloodType(data['data']['DataFor'],data['data']['DataFor'])
            if 'Prescriptions & Medication' in data['data']['Medicals']:
                medical_data['Prescriptions & Medication']=TheCon.GetPrescriptions(data['data']['DataFor'],data['data']['DataFor'])
            if 'Diagnoses' in data['data']['Medicals']:
                medical_data['Diagnoses']=TheCon.GetDiagnoses(data['data']['DataFor'],data['data']['DataFor'])
            if 'Medical Tests' in data['data']['Medicals']:
                medical_data['Medical Tests']=TheCon.GetMedicalTests(data['data']['DataFor'],data['data']['DataFor'])
            
            
            practitioner=session['Practitioner']
            
            return render_template("_onePrac.html",  pp=pp, dc=dc, rez=rez, person=data['data']['DataFor'], 
                                   practitioner=practitioner, pd=data['data']['PersonalDetails'], medical_data=medical_data)
        else:
            return "User Not allowed"
    except  jwt.ExpiredSignatureError:
        flash("This link expired")
        return redirect(url_for('hello'))

    


@app.route('/share/<person>', methods=['POST', 'GET'])
def share(person):
    linkk=linked(person)
    return jsonify('<div id="rnd">'+linkk+' </div>')







































@app.route('/addcompany/', methods=['POST', 'GET'])
def addCompany():
    if request.method=="POST":
        name=request.form['uniName']
        phn=request.form['phone']
        phn1=request.form['phone1']
        mail=request.form['email']
        addr=request.form['addr']

        #riz=TheComp.AddTheCompany(session["UniAddress"],name,addr,phn,mail,phn1)
        flash("Company added, please take note of the public address of the university you just registered. The private key will be sent to their email you provided.")

        return render_template('addCompany.html', riz=riz)
    
    
    return render_template('addCompany.html', riz={'Status':"Add"})


@app.route('/addcourse/', methods=['POST', 'GET'])
def addCourse():
    if request.method=="POST":
        uni=session["UniAddress"]
        name=request.form['CourseName']
        crscode=request.form['CourseCode']
        description=request.form['CourseDescription']
        duration1=request.form['CourseDuration'] 
        durationmsr=request.form['CourseDurationMsr'] #weeks, monhts, years
        crsfield=request.form['CourseField']
        crslevel=request.form['CourseLevel']
        crsstatus="Started"
        crsstart=request.form['CourseStartDate']

        crspre=request.form['CoursePrerequisites']
        crsjobs=request.form['CourseJobs']
        
        duration=duration1+ durationmsr


        print(str(crspre))
        print(str(description))
        print(str(crsjobs))

        


        
        flash("Course added.")
        return render_template('addCourse.html', riz=riz,uni_details=uni_details)
    
    
    return render_template('addCourse.html', riz={'Status':"Add"})


@app.route('/adds/<practitioner>/<person>', methods=['POST', 'GET'])
def bloodType(practitioner, person):
    if request.method=="POST":
        bt=request.form['BloodType']
        rez=TheCon.AddABloodType(bt,person,practitioner)
    
        return render_template('addCourse.html', riz={'Status':"Add"})










if __name__ == '__main__':
    app.run(debug=True)
